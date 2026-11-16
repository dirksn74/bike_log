"""A starting value of 0 km is known, never an estimate

Revision ID: 0025
Revises: 0024
Create Date: 2026-11-16 18:00:00

Dirk 2026-11-16: "why estimated starting value? it is 0" (DECISIONS 151). The Add bike form had "The odometer
value is an estimate" ticked by default, so a new bike entered with 0 km got "≈ 0 km (estimate)" and its total
showed "includes an estimated starting value". 0 km means a new bike or part: nothing before tracking.

* Every active (not voided) starting value of exactly 0 km that is marked as an estimate is marked as known.
  Nothing else changes: the km, the date, the ids and every other row stay as they are; nothing is deleted.
* The rows changed get a marker at the end of their note, so the downgrade can put exactly those back.
* From now on the app stores 0 km as known by itself (inventory.set_starting_usage).
"""
from __future__ import annotations

from alembic import op


revision = '0025'
down_revision = '0024'
branch_labels = None
depends_on = None

MARK = "[0 km marked known by update 0025]"


def upgrade() -> None:
    op.get_bind().exec_driver_sql(
        "UPDATE usage_adjustment SET is_estimate = 0, "
        "note = CASE WHEN note IS NULL OR note = '' THEN ? ELSE note || ' ' || ? END "
        "WHERE kind = 'STARTING' AND km = 0 AND is_estimate = 1 AND voided_at IS NULL", (MARK, MARK))


def downgrade() -> None:
    conn = op.get_bind()
    conn.exec_driver_sql(
        "UPDATE usage_adjustment SET is_estimate = 1, "
        "note = CASE WHEN note = ? THEN NULL ELSE substr(note, 1, length(note) - length(?) - 1) END "
        "WHERE note = ? OR note LIKE ?", (MARK, MARK, MARK, '% ' + MARK))
