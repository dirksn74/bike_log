<?php
declare(strict_types=1);

// Tires are replaced by their own total km (Dirk 2026-11-15: "a tire lasts 6000km"): rule kind LIFETIME.
// Each tire counts its own km on every wheel (front/rear swap), km from before included; an inspection does not
// reset it; a new tire starts at 0.

$now = now_utc();
$uid = Db::insert('users', ['email' => 'tires@example.test', 'display_name' => 'Tires', 'password_hash' => Auth::hash('tire-life-secret'),
    'role' => 'USER', 'status' => 'ACTIVE', 'email_verified_at' => $now, 'timezone' => 'Europe/Berlin', 'created_at' => $now, 'updated_at' => $now]);
Domain::seedUser($uid);
$_SESSION = [];
$bike = Db::insert('bikes', ['user_id' => $uid, 'name' => 'Roadie', 'shifting' => 'ELECTRONIC', 'created_at' => $now, 'updated_at' => $now]);
$ride = fn(string $date, float $km) => Db::insert('rides', ['user_id' => $uid, 'bike_id' => $bike, 'ride_date' => $date,
    'distance_km' => $km, 'duration_s' => 3600, 'kind' => 'OUTDOOR', 'created_at' => $now, 'updated_at' => $now]);
$part = fn(string $type, string $label, array $extra = []) => Inventory::createComponent($uid, ['component_type' => $type, 'label' => $label] + $extra + ['prior_usage' => 'NEW']);
$rem = function (int $cid) use ($uid) {
    foreach (Reminders::forUser($uid, null, $cid) as $r) {
        if (($r['rule']['rule_code'] ?? '') === 'TIRE_REPLACE') {
            return $r;
        }
    }
    return null;
};

$rule = Db::one("SELECT * FROM service_rules WHERE user_id = ? AND rule_code = 'TIRE_REPLACE'", [$uid]);
check($rule && $rule['trigger_kind'] === 'LIFETIME' && (float)$rule['interval_km'] === 6000.0, 'tire replace rule seeded at 6000 km');

$fw = $part('FRONT_WHEEL', 'Front wheel');
$rw = $part('REAR_WHEEL', 'Rear wheel');
Domain::install($uid, $fw, $bike, null, 'FRONT_WHEEL', '2026-01-01');
Domain::install($uid, $rw, $bike, null, 'REAR_WHEEL', '2026-01-01');
$ta = $part('TIRE', 'Tire A');
Domain::install($uid, $ta, null, $fw, 'TIRE', '2026-01-01');
$ride('2026-02-01', 3000.0);
// front tire moves to the rear wheel: it keeps its km
Domain::remove($uid, (int)Domain::openInstallation($uid, $ta)['id'], '2026-03-01', null);
Domain::install($uid, $ta, null, $rw, 'TIRE', '2026-03-01');
$ride('2026-03-02', 2700.0);
$r = $rem($ta);
check($r && $r['status'] === 'SOON' && abs($r['used_km'] - 5700.0) < 0.01, 'km carry over across the swap (5700 km, due soon)');
check(str_contains($r['text'], 'do not say it is safe'), 'reminder never says the tire is safe');
Domain::logMaintenance($uid, ['action_code' => 'TIRE_INSPECT', 'component_id' => $ta, 'bike_id' => null, 'performed_on' => '2026-03-03',
    'outcome' => 'OK', 'measurement_value' => null, 'consumable_id' => null, 'consumable_qty' => null, 'cost_cents' => null, 'shop' => null, 'notes' => null]);
$r = $rem($ta);
check($r['status'] === 'SOON' && str_contains($r['text'], '2026-03-03'), 'an inspection is quoted but does not reset it');
$ride('2026-03-04', 400.0);
check($rem($ta)['status'] === 'OVERDUE', 'over 6000 km: due');

// a new tire starts at 0
Domain::remove($uid, (int)Domain::openInstallation($uid, $ta)['id'], '2026-03-05', null);
$tb = $part('TIRE', 'Tire B');
Domain::install($uid, $tb, null, $rw, 'TIRE', '2026-03-05');
$r = $rem($tb);
check($r && $r['status'] === 'OK' && $r['used_km'] == 0.0, 'new tire starts at 0 km');

// km from before unknown: never shown as fine
$tc = $part('TIRE', 'Old tire', ['prior_usage' => 'UNKNOWN']);
Domain::install($uid, $tc, null, $fw, 'TIRE', '2026-03-05');
check($rem($tc)['status'] === 'UNKNOWN', 'unknown earlier use: insufficient information');
