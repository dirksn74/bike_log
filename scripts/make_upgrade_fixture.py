"""Make a test database from an OLDER version of Bike Log, for the upgrade tests.

    python scripts/make_upgrade_fixture.py v0.3.0
    python scripts/make_upgrade_fixture.py e95b486 --name v0.2.0

It checks the given git commit or tag out into a temporary folder, lets THAT version's own code create a
database with its sample data (or its demo data, for versions before the sample), and writes the database as
plain SQL text to backend/tests/fixtures/upgrade/<name>.sql. backend/tests/test_upgrade_real_data.py loads
every file there, upgrades it with the current migrations and checks that nothing was lost.

Rule (docs/PROJECT_GUIDE_FOR_AI_AGENTS.md, "Existing data is production data"): after each release, add a
fixture for it, so the next migrations are tested against what people really have. The data is made up
(demo/sample data), never a real person's database.
"""
from __future__ import annotations

import argparse
import os
import sqlite3
import subprocess
import sys
import tempfile
from contextlib import closing
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
OUT = REPO / "backend" / "tests" / "fixtures" / "upgrade"
TODAY = "2026-10-20"      # fixed, so a re-made fixture has the same dates

SEED = r"""
import sys
from datetime import date
from pathlib import Path
from bikelog.paths import DataPaths
from bikelog import launcher
from bikelog.db import session_scope
from bikelog.services import demo
paths = DataPaths(Path(sys.argv[1])).ensure()
engine, factory, _ = launcher.prepare(paths)
today = date.fromisoformat(sys.argv[2])
with session_scope(factory) as s:
    if hasattr(demo, "seed_sample"):   # the richer sample (bikes, groupsets, wheels, chains, incidents ...)
        demo.seed_sample(s, today=today)
    else:
        demo.mark_demo_database(s)
        demo.seed(s, today=today)
engine.dispose()
"""


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("ref", help="git tag or commit of the older version")
    ap.add_argument("--name", help="fixture name (default: the ref)")
    args = ap.parse_args()
    name = args.name or args.ref
    with tempfile.TemporaryDirectory() as tmp:
        wt = Path(tmp) / "src"
        subprocess.run(["git", "-C", str(REPO), "worktree", "add", "--detach", str(wt), args.ref], check=True)
        try:
            data = Path(tmp) / "data"
            env = {**os.environ, "PYTHONPATH": str(wt / "backend")}
            subprocess.run([sys.executable, "-c", SEED, str(data), TODAY], check=True, env=env, cwd=tmp)
            db = data / "data" / "bikelog.db"
            with closing(sqlite3.connect(db)) as c:
                rev = c.execute("SELECT version_num FROM alembic_version").fetchone()[0]
                lines = list(c.iterdump())
        finally:
            subprocess.run(["git", "-C", str(REPO), "worktree", "remove", "--force", str(wt)], check=True)
    OUT.mkdir(parents=True, exist_ok=True)
    dest = OUT / f"{name}.sql"
    header = f"-- Bike Log {name} (schema revision {rev}), demo/sample data made by that version's own code.\n"
    dest.write_text(header + "\n".join(lines) + "\n", encoding="utf-8")
    print(f"{dest.relative_to(REPO)}: schema {rev}, {dest.stat().st_size // 1024} KB")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
