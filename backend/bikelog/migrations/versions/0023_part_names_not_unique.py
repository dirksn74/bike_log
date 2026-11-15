"""Part names no longer need to be unique

Revision ID: 0023
Revises: 0022
Create Date: 2026-11-15 18:00:00

Dirk 2026-11-15: renaming a part failed ("UNIQUE constraint failed: component.component_type, component.label");
part names should not have to be unique, several spares may share a name, the internal id is the key. He also
wants to add e.g. 15 inner tubes at once (DECISIONS 144).

* The unique index uq_component_type_label (since 0020: every type except tires and tubes) is dropped and a
  plain index on (component_type, label) takes its place for lookups. No data changes: every row stays as it is.
* Downgrade numbers equal names back ("name (2)") before putting the unique index back.
"""
from alembic import op
import sqlalchemy as sa


revision = '0023'
down_revision = '0022'
branch_labels = None
depends_on = None

SAME_NAME = ('TIRE', 'INNER_TUBE')


def upgrade() -> None:
    op.execute("DROP INDEX IF EXISTS uq_component_type_label")
    op.execute("CREATE INDEX IF NOT EXISTS ix_component_type_label ON component (component_type, label)")


def downgrade() -> None:
    conn = op.get_bind()
    seen: dict[tuple, int] = {}
    taken = {(t, (l or "").lower()) for t, l in conn.execute(sa.text("SELECT component_type, label FROM component"))}
    for cid, ctype, label in conn.execute(sa.text(
            "SELECT id, component_type, label FROM component ORDER BY id")).fetchall():
        if ctype in SAME_NAME:
            continue
        key = (ctype, label.lower())
        seen[key] = seen.get(key, 0) + 1
        if seen[key] > 1:
            n = seen[key]
            while (ctype, f"{label} ({n})".lower()) in taken:
                n += 1
            taken.add((ctype, f"{label} ({n})".lower()))
            conn.execute(sa.text("UPDATE component SET label = :l WHERE id = :i"), {"l": f"{label} ({n})", "i": cid})
    op.execute("DROP INDEX IF EXISTS ix_component_type_label")
    op.execute("CREATE UNIQUE INDEX uq_component_type_label ON component (component_type, label) "
               f"WHERE component_type NOT IN {SAME_NAME!r}")
