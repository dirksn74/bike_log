-- Replace a tire by its own total km (Dirk 2026-11-15: "a tire lasts 6000km"). New rule kind LIFETIME: due when
-- the part's own total km (km from before, adjustments and every ride on any wheel and bike) reach interval_km.
-- Nothing logged resets it; a new tire starts at 0. Existing rules and data are not changed.

ALTER TABLE service_rules
  MODIFY trigger_kind ENUM('INTERVAL','ONCE_AFTER_INSTALL','CYCLE_WINDOW','PARENT_COUNT','LIFETIME') NOT NULL DEFAULT 'INTERVAL';

INSERT IGNORE INTO service_rules (user_id, rule_code, name, component_type, action_code, reset_actions, trigger_kind, interval_km,
  warn_km, origin, active, notes, created_at, updated_at)
  SELECT id, 'TIRE_REPLACE', 'Replace tire', 'TIRE', 'TIRE_INSPECT', '', 'LIFETIME', 6000, 500, 'DEFAULT', 1,
  'Personal value (Dirk 2026-11-15: a tire lasts about 6,000 km). Counts the tire''s own total km on every wheel and bike, km from before included; logging work does not reset it, a new tire starts at 0. Replace sooner when the tread is worn, cut or the sidewalls crack.',
  UTC_TIMESTAMP(), UTC_TIMESTAMP() FROM users;
