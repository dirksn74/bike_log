"""Rules by a part's total km (LIFETIME): replace a tire at 6,000 km

Revision ID: 0024
Revises: 0023
Create Date: 2026-11-15 22:00:00

Dirk 2026-11-15: "we need to add tires to service intervals. a tire lasts 6000km" (DECISIONS 150).

* service_rule.trigger accepts LIFETIME: due when the part's own total km (km from before, corrections and every
  ride on any wheel or bike) reach interval_km. Nothing logged resets it; a new part starts at 0.
* The CHECK constraint can only change by rebuilding the table (SQLite). The table is rebuilt from its own stored
  definition with only the trigger list changed, every row is copied with its id and uuid, and the indexes and
  SQLite triggers are put back exactly as they were. Nothing else changes.
* The rule itself (TIRE_REPLACE, type default for every tire) is added at start by ensure_reference_data, like
  every new default rule.
Downgrade removes LIFETIME rules (and their snoozes) and puts the old trigger list back.
"""
from __future__ import annotations

import re

from alembic import op


revision = '0024'
down_revision = '0023'
branch_labels = None
depends_on = None

OLD = "trigger IN ('INTERVAL','CYCLE_WINDOW','PARENT_COUNT','ONCE_AFTER_INSTALL')"
NEW = "trigger IN ('INTERVAL','CYCLE_WINDOW','PARENT_COUNT','ONCE_AFTER_INSTALL','LIFETIME')"
LIFETIME_CHECK = ",\n        CONSTRAINT ck_rule_lifetime CHECK (trigger <> 'LIFETIME' OR interval_km IS NOT NULL)"


def _rebuild(change) -> None:
    conn = op.get_bind()
    create = conn.exec_driver_sql(
        "SELECT sql FROM sqlite_master WHERE type = 'table' AND name = 'service_rule'").scalar_one()
    extras = [r[0] for r in conn.exec_driver_sql(
        "SELECT sql FROM sqlite_master WHERE tbl_name = 'service_rule' AND type IN ('index', 'trigger') "
        "AND sql IS NOT NULL ORDER BY type, name")]
    cols = ", ".join(f'"{r[1]}"' for r in conn.exec_driver_sql("PRAGMA table_info(service_rule)"))
    new_create = change(create)
    new_create, n = re.subn(r'^CREATE TABLE\s+("service_rule"|service_rule)\s*\(', 'CREATE TABLE service_rule_new (',
                            new_create, count=1)
    if n != 1:
        raise RuntimeError("service_rule: unexpected table definition, nothing changed")
    before = conn.exec_driver_sql("SELECT COUNT(*) FROM service_rule").scalar_one()
    op.execute(new_create)
    op.execute(f"INSERT INTO service_rule_new ({cols}) SELECT {cols} FROM service_rule")
    op.execute("DROP TABLE service_rule")
    op.execute("ALTER TABLE service_rule_new RENAME TO service_rule")
    for sql in extras:
        op.execute(sql)
    after = conn.exec_driver_sql("SELECT COUNT(*) FROM service_rule").scalar_one()
    if after != before:
        raise RuntimeError(f"service_rule: {before} rules before the rebuild, {after} after; nothing changed")


def upgrade() -> None:
    def change(sql: str) -> str:
        if OLD not in sql:
            raise RuntimeError("service_rule: trigger list not found, nothing changed")
        sql = sql.replace(OLD, NEW, 1)
        i = sql.rindex(")")                       # the table's closing bracket
        return sql[:i].rstrip() + LIFETIME_CHECK + "\n)" + sql[i + 1:]
    _rebuild(change)


def downgrade() -> None:
    op.execute("DELETE FROM reminder_snooze WHERE rule_code IN (SELECT rule_code FROM service_rule "
               "WHERE trigger = 'LIFETIME')")
    op.execute("DELETE FROM service_rule WHERE trigger = 'LIFETIME'")

    def change(sql: str) -> str:
        return sql.replace(NEW, OLD, 1).replace(LIFETIME_CHECK, "", 1)
    _rebuild(change)
