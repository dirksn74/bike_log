"""Common road bike products (brand + model) offered when you add or edit a part (DECISIONS 149).

A pick list only: nothing here is written to the database until you choose an entry for a part; then a
product row is made (or the one you already have is reused) with spec_source COMMON_SOURCE, which marks
it as unverified (no specs, typed from memory, not checked against the maker's site). You can always type
a brand or model that is not listed.

Sizes (28 mm, 160 mm, 11-34) are not part of the model: they go into the part's properties.
`aliases` are other ways people write the model in a part name ("GP5000" for "Grand Prix 5000"); they are
used only to suggest a product for parts that have a name but no product yet.
"""
from __future__ import annotations

import re
from dataclasses import dataclass, field

COMMON_SOURCE = "Bike Log common list (unverified)"

# Short or other names of brands as they appear in part names.
MAKER_ALIASES: dict[str, tuple[str, ...]] = {
    "Continental": ("Conti",),
    "Schwalbe": (),
    "Shimano": (),
    "SRAM": (),
    "Campagnolo": ("Campa", "Campy"),
    "Pirelli": (),
    "Vittoria": (),
    "Michelin": (),
    "Specialized": ("S-Works",),
    "SwissStop": ("Swiss Stop",),
    "Kool-Stop": ("Koolstop", "Kool Stop"),
    "Silca": (),
    "Squirt": (),
    "Muc-Off": ("Muc Off", "MucOff"),
    "Fizik": ("Fi'zi:k", "fizik"),
    "Look": (),
    "Wahoo": (),
    "Garmin": (),
    "Favero": (),
    "Magene": (),
    "Wippermann": (),
    "Supacaz": (),
    "Lizard Skins": ("LizardSkins",),
    "Tubolito": (),
    "Revoloop": (),
    "Ritchey": (),
    "Zipp": (),
    "DT Swiss": ("DT",),
    "Mavic": (),
    "Fulcrum": (),
    "Hunt": (),
}


@dataclass(frozen=True)
class Common:
    maker: str
    model: str
    aliases: tuple[str, ...] = field(default_factory=tuple)


def _c(maker: str, model: str, *aliases: str) -> Common:
    return Common(maker, model, aliases)


# Per part type. Keep each list short: the brands and lines most road riders meet.
COMMON_PRODUCTS: dict[str, list[Common]] = {
    "TIRE": [
        _c("Continental", "Grand Prix 5000 S TR", "GP5000 S TR", "GP 5000 S TR", "GP5000S TR", "GP5000STR"),
        _c("Continental", "Grand Prix 5000", "GP5000", "GP 5000"),
        _c("Continental", "Grand Prix 5000 AS TR", "GP5000 AS TR", "GP 5000 AS TR"),
        _c("Continental", "Grand Prix 4 Season", "GP4000 4 Season", "4 Season", "4Season"),
        _c("Continental", "Grand Prix 4000 S II", "GP4000 S II", "GP4000", "GP 4000"),
        _c("Continental", "Aero 111"),
        _c("Continental", "Ultra Sport III"),
        _c("Continental", "Gatorskin"),
        _c("Schwalbe", "Pro One TLE", "Pro One"),
        _c("Schwalbe", "One"),
        _c("Schwalbe", "Durano Plus", "Durano"),
        _c("Schwalbe", "Lugano II", "Lugano"),
        _c("Pirelli", "P Zero Race", "PZero Race"),
        _c("Pirelli", "P Zero Race TLR", "PZero Race TLR"),
        _c("Pirelli", "P Zero Road", "PZero Road"),
        _c("Pirelli", "Cinturato Velo"),
        _c("Vittoria", "Corsa Pro", "Corsa Pro Control"),
        _c("Vittoria", "Corsa N.EXT", "Corsa NEXT", "Corsa Next"),
        _c("Vittoria", "Rubino Pro", "Rubino"),
        _c("Vittoria", "Zaffiro Pro", "Zaffiro"),
        _c("Michelin", "Power Cup"),
        _c("Michelin", "Power Road"),
        _c("Michelin", "Pro4"),
        _c("Specialized", "S-Works Turbo", "Turbo Cotton", "Turbo"),
        _c("Specialized", "S-Works Mondo", "Mondo"),
        _c("Goodyear", "Eagle F1", "Eagle F1 SuperSport"),
        _c("Panaracer", "Agilest", "Agilest Duro"),
        _c("Panaracer", "Gravelking"),
    ],
    "INNER_TUBE": [
        _c("Continental", "Race 28", "Race28", "Race 28 Light", "Race28 Light"),
        _c("Continental", "Race 28 Supersonic", "Supersonic"),
        _c("Schwalbe", "SV15", "SV 15"),
        _c("Schwalbe", "Aerothan", "Aerothan Race"),
        _c("Michelin", "Air Comp Latex", "Latex"),
        _c("Michelin", "Air Stop", "Airstop"),
        _c("Vittoria", "Competition Latex", "Latex"),
        _c("Pirelli", "P Zero SmarTUBE", "SmarTUBE", "Smartube"),
        _c("Tubolito", "Tubo Road", "S-Tubo Road", "Tubo-Road"),
        _c("Revoloop", "Race Ultra", "Ultra", "Race"),
        _c("Specialized", "Turbo Ultralight TPU"),
        _c("Decathlon", "Van Rysel TPU"),
    ],
    "CHAIN": [
        _c("Shimano", "Dura-Ace CN-M9100", "CN-M9100", "M9100", "Dura Ace 12"),
        _c("Shimano", "Dura-Ace CN-HG901-11", "CN-HG901", "HG901"),
        _c("Shimano", "Ultegra CN-M8100", "CN-M8100", "M8100"),
        _c("Shimano", "Ultegra CN-HG701-11", "CN-HG701", "HG701"),
        _c("Shimano", "105 CN-M7100", "CN-M7100", "M7100"),
        _c("Shimano", "105 CN-HG601-11", "CN-HG601", "HG601"),
        _c("SRAM", "Red Flattop", "Red AXS chain"),
        _c("SRAM", "Force Flattop", "Force AXS chain"),
        _c("SRAM", "Rival Flattop", "Rival AXS chain"),
        _c("SRAM", "PC-1170", "PC1170"),
        _c("Campagnolo", "Record 12", "Record 12s"),
        _c("Campagnolo", "Chorus 12", "Chorus 12s"),
        _c("KMC", "X12", "X12 SL", "X-12"),
        _c("KMC", "X11", "X11 SL", "X-11", "X11SL"),
        _c("KMC", "X11 EL", "X11EL"),
        _c("YBN", "SLA-H12", "SLA H12"),
        _c("Wippermann", "Connex 11SX", "11SX", "Connex 11 SX"),
        _c("Wippermann", "Connex 12SX", "12SX"),
    ],
    "QUICK_LINK": [
        _c("Wippermann", "Connex Link 11s", "Connex Link 11", "Connex 11"),
        _c("Wippermann", "Connex Link 12s", "Connex Link 12", "Connex 12"),
        _c("Shimano", "SM-CN910-12 Quick Link", "SM-CN910-12", "CN910"),
        _c("Shimano", "SM-CN900-11 Quick Link", "SM-CN900-11", "CN900"),
        _c("SRAM", "PowerLock 11", "PowerLink 11"),
        _c("SRAM", "PowerLock Flattop", "PowerLock 12"),
        _c("KMC", "MissingLink 11", "Missing Link 11"),
        _c("KMC", "MissingLink 12", "Missing Link 12"),
    ],
    "CASSETTE": [
        _c("Shimano", "Dura-Ace CS-R9200", "CS-R9200", "R9200"),
        _c("Shimano", "Dura-Ace CS-R9100", "CS-R9100", "R9100"),
        _c("Shimano", "Ultegra CS-R8100", "CS-R8100", "R8100"),
        _c("Shimano", "Ultegra CS-R8000", "CS-R8000", "R8000"),
        _c("Shimano", "105 CS-R7100", "CS-R7100", "R7100"),
        _c("Shimano", "105 CS-R7000", "CS-R7000", "R7000"),
        _c("SRAM", "Red XG-1290", "XG-1290"),
        _c("SRAM", "Force XG-1270", "XG-1270"),
        _c("SRAM", "Rival XG-1250", "XG-1250"),
        _c("Campagnolo", "Record 12"),
        _c("Campagnolo", "Chorus 12"),
    ],
    "BRAKE_PADS": [
        _c("Shimano", "L05A-RF Resin", "L05A", "L05A-RF"),
        _c("Shimano", "L04C-MF Metal", "L04C", "L04C-MF"),
        _c("Shimano", "L03A Resin", "L03A"),
        _c("Shimano", "K05S-RX Resin", "K05S"),
        _c("Shimano", "K04Ti-MX Metal", "K04Ti", "K04S"),
        _c("SRAM", "Road Organic", "Organic"),
        _c("SRAM", "Road Sintered", "Sintered"),
        _c("SwissStop", "Disc 34 RS", "Disc 34", "34 RS"),
        _c("SwissStop", "Disc 34 E", "34 E"),
        _c("Kool-Stop", "D635 Organic", "D635"),
        _c("Galfer", "FD502 Road", "FD502"),
        _c("Campagnolo", "DB-310"),
    ],
    "BRAKE_ROTOR": [
        _c("Shimano", "Dura-Ace RT-CL900", "RT-CL900", "CL900"),
        _c("Shimano", "Ultegra RT-CL800", "RT-CL800", "CL800"),
        _c("Shimano", "RT-MT800", "MT800"),
        _c("Shimano", "RT-MT900", "MT900"),
        _c("Shimano", "RT-CL700", "CL700"),
        _c("SRAM", "Paceline", "Paceline X"),
        _c("SRAM", "Centerline XR", "CenterLine XR"),
        _c("SwissStop", "Catalyst Pro", "Catalyst"),
        _c("Campagnolo", "Disc Brake Rotor AFS"),
    ],
    "BAR_TAPE": [
        _c("Supacaz", "Super Sticky Kush", "Sticky Kush"),
        _c("Lizard Skins", "DSP 2.5", "DSP 2.5mm", "DSP"),
        _c("Lizard Skins", "DSP 3.2", "DSP 3.2mm"),
        _c("Fizik", "Vento Microtex Tacky", "Vento"),
        _c("Fizik", "Tempo Microtex", "Tempo"),
        _c("Specialized", "S-Wrap", "S Wrap"),
        _c("PRO", "Sport Control"),
        _c("Zipp", "Service Course CX"),
    ],
    "CLEATS": [
        _c("Look", "Keo Grip Red", "Keo Grip", "Keo Red"),
        _c("Look", "Keo Grip Grey", "Keo Grey"),
        _c("Look", "Keo Grip Black", "Keo Black"),
        _c("Shimano", "SM-SH12 Yellow", "SM-SH12", "SH12", "yellow"),
        _c("Shimano", "SM-SH11 Red", "SM-SH11", "SH11"),
        _c("Shimano", "SM-SH10 Red fixed", "SM-SH10", "SH10"),
        _c("Favero", "Assioma cleats (Look Keo)", "Assioma cleats"),
        _c("Time", "Iclic", "ICLIC"),
        _c("Speedplay", "Zero Aero walkable", "Zero cleats"),
    ],
    "PEDALS": [
        _c("Shimano", "Dura-Ace PD-R9100", "PD-R9100", "R9100"),
        _c("Shimano", "Ultegra PD-R8000", "PD-R8000", "R8000"),
        _c("Shimano", "105 PD-R7000", "PD-R7000", "R7000"),
        _c("Look", "Keo Blade Carbon", "Keo Blade"),
        _c("Look", "Keo 2 Max", "Keo 2Max"),
        _c("Time", "XPro 12", "Xpresso"),
        _c("Wahoo", "Speedplay Zero", "Speedplay"),
    ],
    "POWER_METER_PEDALS": [
        _c("Favero", "Assioma Pro RS-1", "Assioma Pro RS1", "Pro RS-1", "Pro RS1"),
        _c("Favero", "Assioma Pro RS-2", "Assioma Pro RS2", "Pro RS-2", "Pro RS2"),
        _c("Favero", "Assioma Duo", "Assioma DUO"),
        _c("Favero", "Assioma Uno", "Assioma UNO"),
        _c("Garmin", "Rally RS200", "RS200"),
        _c("Garmin", "Rally RS100", "RS100"),
        _c("Look", "Keo Blade Power", "Exakt"),
        _c("Wahoo", "Powrlink Zero", "Powrlink"),
        _c("SRM", "X-Power", "XPower"),
    ],
    "SENSOR": [
        _c("Magene", "S3+ speed/cadence", "S3+", "S3 plus", "S3"),
        _c("Wahoo", "RPM Speed", "RPM"),
        _c("Garmin", "Speed Sensor 2"),
        _c("Garmin", "Cadence Sensor 2"),
        _c("Garmin", "HRM-Pro Plus", "HRM-Pro", "HRM Pro"),
    ],
    "BIKE_COMPUTER": [
        _c("Garmin", "Edge 1050"),
        _c("Garmin", "Edge 1040", "Edge 1040 Solar"),
        _c("Garmin", "Edge 840", "Edge 840 Solar"),
        _c("Garmin", "Edge 540"),
        _c("Wahoo", "Elemnt Roam", "Roam"),
        _c("Wahoo", "Elemnt Bolt", "Bolt"),
        _c("Hammerhead", "Karoo", "Karoo 3", "Karoo 2"),
    ],
    "RADAR": [
        _c("Garmin", "Varia RTL515", "RTL515", "Varia"),
        _c("Garmin", "Varia RCT715", "RCT715"),
        _c("Magene", "L508", "L508 Radar"),
    ],
    "BATTERY": [
        _c("Shimano", "BT-DN300", "BT DN300", "DN300"),
        _c("Shimano", "BT-DN110", "BT DN110", "DN110"),
        _c("SRAM", "AXS battery", "eTap battery"),
    ],
    "BOTTOM_BRACKET": [
        _c("Shimano", "SM-BBR60", "BBR60", "BB-R60"),
        _c("Shimano", "BB-RS500", "RS500"),
        _c("Shimano", "BB72-41B", "BB72"),
        _c("Shimano", "BB92-41B", "BB92"),
        _c("CeramicSpeed", "BB"),
        _c("CEMA", "Interlock"),
        _c("Wheels Manufacturing", "BB86 to Shimano"),
        _c("SRAM", "DUB BB", "DUB"),
    ],
    "PULLEY_WHEEL": [
        _c("Shimano", "Dura-Ace RD-R9250 pulley set", "R9250 pulley"),
        _c("Shimano", "Ultegra RD-R8150 pulley set", "R8150 pulley"),
        _c("CeramicSpeed", "OSPW", "OSPW system"),
        _c("Kogel", "Kolossos"),
    ],
    "DERAILLEUR_HANGER": [
        _c("Pilo", "Replacement hanger"),
        _c("Wheels Manufacturing", "Replacement hanger"),
        _c("SRAM", "UDH", "Universal Derailleur Hanger"),
    ],
    "HEADSET": [
        _c("Cane Creek", "40 series", "40-series"),
        _c("Cane Creek", "110 series", "110-series"),
        _c("FSA", "Orbit", "No. 42"),
        _c("Chris King", "InSet", "Inset"),
    ],
    "SADDLE": [
        _c("Fizik", "Antares Versus Evo", "Antares"),
        _c("Fizik", "Argo Vento", "Argo"),
        _c("Specialized", "Power", "Power Expert", "Power Pro"),
        _c("Specialized", "Romin Evo", "Romin"),
        _c("Prologo", "Scratch M5", "Scratch"),
        _c("Selle Italia", "SLR Boost", "SLR"),
        _c("Selle Italia", "Flite"),
        _c("SMP", "Dynamic"),
        _c("Ergon", "SR Pro", "SR Comp"),
    ],
    "HANDLEBAR": [
        _c("Zipp", "Service Course SL-70", "SL-70", "SL70"),
        _c("Ritchey", "WCS Streem", "Streem"),
        _c("PRO", "Vibe", "Vibe Alloy", "Vibe Carbon"),
        _c("Deda", "Zero100"),
    ],
    "STEM": [
        _c("Zipp", "Service Course SL"),
        _c("Ritchey", "WCS C220", "C220"),
        _c("PRO", "Vibe"),
    ],
    "SEATPOST": [
        _c("Ritchey", "WCS Carbon", "WCS"),
        _c("Zipp", "Service Course SL"),
        _c("PRO", "Discover"),
    ],
    "WHEELSET": [
        _c("DT Swiss", "ARC 1400 Dicut", "ARC 1400"),
        _c("DT Swiss", "ERC 1400 Dicut", "ERC 1400"),
        _c("DT Swiss", "PR 1600 Spline", "PR 1600"),
        _c("Zipp", "303 Firecrest", "303 FC"),
        _c("Zipp", "404 Firecrest", "404 FC"),
        _c("Mavic", "Ksyrium SL Disc", "Ksyrium"),
        _c("Fulcrum", "Racing 3 DB", "Racing 3"),
        _c("Fulcrum", "Racing Zero", "Racing 0"),
        _c("Shimano", "Dura-Ace WH-R9270", "WH-R9270", "C50", "C36"),
        _c("Shimano", "Ultegra WH-R8170", "WH-R8170"),
        _c("Hunt", "Aerodynamicist", "Aero Wide"),
        _c("Roval", "Rapide CLX", "Rapide"),
        _c("Roval", "Alpinist CLX", "Alpinist"),
    ],
    "FRONT_WHEEL": [],
    "REAR_WHEEL": [],
    "RIM_TAPE": [
        _c("Schwalbe", "High Pressure rim tape", "HP rim tape"),
        _c("Velox", "Rim tape"),
        _c("Stan's", "Rim tape", "NoTubes"),
    ],
    "CRANKSET": [
        _c("Shimano", "Dura-Ace FC-R9200", "FC-R9200"),
        _c("Shimano", "Ultegra FC-R8100", "FC-R8100"),
        _c("Shimano", "105 FC-R7100", "FC-R7100"),
        _c("SRAM", "Force AXS crankset"),
        _c("SRAM", "Rival AXS crankset"),
    ],
    "CHAINRING": [
        _c("Shimano", "Dura-Ace R9200 chainring"),
        _c("Shimano", "Ultegra R8100 chainring"),
        _c("Absolute Black", "Oval road", "Oval"),
    ],
    "SHOES": [
        _c("Shimano", "S-Phyre RC903", "RC903", "S-Phyre"),
        _c("Shimano", "RC702", "RC7"),
        _c("Specialized", "S-Works Ares", "Ares"),
        _c("Specialized", "Torch"),
        _c("Fizik", "Vento Infinito", "Infinito"),
        _c("Sidi", "Wire 2", "Wire"),
        _c("Giro", "Imperial"),
    ],
}
# Front and rear wheels come from the same wheelset lines.
COMMON_PRODUCTS["FRONT_WHEEL"] = list(COMMON_PRODUCTS["WHEELSET"])
COMMON_PRODUCTS["REAR_WHEEL"] = list(COMMON_PRODUCTS["WHEELSET"])


def for_type(component_type: str) -> list[Common]:
    return COMMON_PRODUCTS.get(component_type, [])


def as_rows(component_type: str) -> list[dict]:
    return [{"maker": c.maker, "model": c.model} for c in for_type(component_type)]


_NORM = re.compile(r"[^0-9a-zäöüß+]+")


def norm(text: str | None) -> str:
    """'Continental Grand-Prix 5000 S TR 28"' -> ' continental grand prix 5000 s tr 28 ' (padded with spaces)."""
    return f" {_NORM.sub(' ', (text or '').lower()).strip()} "


def _contains(hay: str, needle: str) -> bool:
    n = norm(needle)
    return len(n.strip()) > 0 and n in hay


def maker_in(name_norm: str, maker: str | None) -> bool:
    if not maker:
        return False
    return any(_contains(name_norm, m) for m in (maker, *MAKER_ALIASES.get(maker, ())))


def score(name: str, maker: str | None, model: str, aliases: tuple[str, ...] = ()) -> int:
    """How well a part name matches a product (0 = not at all). The model (or one of its other names) must
    appear in the name as whole words; a longer match and the brand in the name score higher, so
    'Grand Prix 5000 S TR' beats 'Grand Prix 5000' for a GP5000 S TR tire."""
    hay = norm(name)
    best = 0
    for m in (model, *aliases):
        if _contains(hay, m):
            best = max(best, len(norm(m).strip()))
    if not best:
        return 0
    has_maker = maker_in(hay, maker)
    if not has_maker and best < 6:
        return 0            # "One" or "Race" alone, without the brand, says too little
    return best + (100 if has_maker else 0)
