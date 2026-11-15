"""Brand and model for a part (DECISIONS 149): the pick list, finding or making the product row, and
suggesting a product for parts that have only a name.

A part's brand and model live on its product row (product.maker, product.model), never on the part, so
several parts of one model share one product and the Part life report can average them. Picking a brand
and model that you already have reuses that product (case does not matter); a new one makes a product
row: from the common list it is marked unverified (COMMON_SOURCE), typed in it is "manual".
"""
from __future__ import annotations

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from bikelog.catalog import COMPONENT_TYPES
from bikelog.common_products import COMMON_SOURCE, for_type, score
from bikelog.i18n import tr
from bikelog.models import Component, Product
from bikelog.services import inventory as inv
from bikelog.services.errors import DomainError

MANUAL_SOURCE = "manual"


def _key(maker: str | None, model: str | None) -> tuple[str, str]:
    return ((maker or "").strip().lower(), (model or "").strip().lower())


def choices(session: Session, component_type: str) -> dict:
    """Brands and models to offer for one part type: your own products first, then the common list."""
    if component_type not in COMPONENT_TYPES:
        raise DomainError(tr("Unknown component type {code}", code=repr(component_type)))
    rows: list[dict] = []
    seen: set[tuple[str, str]] = set()
    for p in session.scalars(select(Product).where(Product.component_type == component_type)
                             .order_by(func.lower(Product.maker), func.lower(Product.model))):
        k = _key(p.maker, p.model)
        if k in seen:
            continue
        seen.add(k)
        rows.append({"product_id": p.id, "maker": p.maker, "model": p.model, "saved": True,
                     "unverified": p.spec_source == COMMON_SOURCE})
    for c in for_type(component_type):
        k = _key(c.maker, c.model)
        if k in seen:
            continue
        seen.add(k)
        rows.append({"product_id": None, "maker": c.maker, "model": c.model, "saved": False, "unverified": True})
    makers = sorted({r["maker"] for r in rows if r["maker"]}, key=str.lower)
    return {"makers": makers, "products": rows}


def find(session: Session, component_type: str, maker: str | None, model: str) -> Product | None:
    k = _key(maker, model)
    for p in session.scalars(select(Product).where(Product.component_type == component_type,
                                                   func.lower(Product.model) == k[1]).order_by(Product.id)):
        if _key(p.maker, p.model) == k:
            return p
    return None


def resolve(session: Session, component_type: str, maker: str | None, model: str | None) -> Product | None:
    """The product for this brand and model: yours if you have it, else a new one. Both empty = None."""
    maker = (maker or "").strip() or None
    model = (model or "").strip() or None
    if not maker and not model:
        return None
    if not model:
        raise DomainError(tr("Enter the model too (the brand alone is not a product)"))
    existing = find(session, component_type, maker, model)
    if existing:
        return existing
    common = next((c for c in for_type(component_type) if _key(c.maker, c.model) == _key(maker, model)), None)
    if common:
        maker, model = common.maker, common.model      # the list's spelling
    return inv.create_product(session, component_type=component_type, maker=maker, model=model,
                              spec_source=COMMON_SOURCE if common else MANUAL_SOURCE)


def set_product(session: Session, component_id: int, maker: str | None, model: str | None) -> Component:
    """Give a part its brand and model (or clear them with both empty)."""
    comp = inv.get_component(session, component_id)
    prod = resolve(session, comp.component_type, maker, model)
    return inv.update_component(session, comp.id, product_id=prod.id if prod else None)


def suggest(session: Session, comp: Component) -> dict | None:
    """The product its name most likely means, or None. Your own products win a tie over the common list."""
    return suggest_for(session, comp.component_type, comp.label)


def suggest_for(session: Session, component_type: str, name: str) -> dict | None:
    best: tuple[int, int, dict] | None = None
    aliases = {_key(c.maker, c.model): c.aliases for c in for_type(component_type)}
    for p in session.scalars(select(Product).where(Product.component_type == component_type)):
        sc = score(name, p.maker, p.model, aliases.get(_key(p.maker, p.model), ()))
        if sc and (best is None or (sc, 1) > best[:2]):
            best = (sc, 1, {"product_id": p.id, "maker": p.maker, "model": p.model, "saved": True})
    for c in for_type(component_type):
        sc = score(name, c.maker, c.model, c.aliases)
        if sc and (best is None or (sc, 0) > best[:2]):
            best = (sc, 0, {"product_id": None, "maker": c.maker, "model": c.model, "saved": False})
    return best[2] if best else None


def unlinked(session: Session) -> list[dict]:
    """Parts with a name but no brand and model, each with a suggestion when the name gives one away."""
    q = (select(Component).where(Component.product_id.is_(None), Component.disposition != "VOIDED",
                                 Component.component_type.in_(list(COMPONENT_TYPES)))
         .order_by(Component.component_type, Component.label, Component.id))
    out = []
    for c in session.scalars(q):
        t = COMPONENT_TYPES[c.component_type]
        out.append({"id": c.id, "label": c.label, "component_type": c.component_type, "type_name": t.name,
                    "status": c.status, "suggestion": suggest(session, c)})
    return out


def link_many(session: Session, links: list[dict]) -> dict:
    """Set brand and model on several parts at once ([{component_id, maker, model}])."""
    done = []
    for ln in links:
        comp = set_product(session, int(ln["component_id"]), ln.get("maker"), ln.get("model"))
        done.append(comp.id)
    return {"linked": done}
