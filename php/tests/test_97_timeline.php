<?php
declare(strict_types=1);

// Timeline of a bike and of a part: what was done at what km, replacements in one row, filters, CSV.

$now = now_utc();
$uid = Db::insert('users', ['email' => 'timeline@example.test', 'display_name' => 'Timeline', 'password_hash' => Auth::hash('timeline-tester-pw'),
    'role' => 'USER', 'status' => 'ACTIVE', 'email_verified_at' => $now, 'timezone' => 'Europe/Berlin', 'created_at' => $now, 'updated_at' => $now]);
Domain::seedUser($uid);
$bike = Db::insert('bikes', ['user_id' => $uid, 'name' => 'TIME NXR', 'created_at' => $now, 'updated_at' => $now]);
$bike2 = Db::insert('bikes', ['user_id' => $uid, 'name' => 'BMC', 'created_at' => $now, 'updated_at' => $now]);
$part = fn(string $type, string $label) => Inventory::createComponent($uid, ['component_type' => $type, 'label' => $label, 'prior_usage' => 'NEW']);
$ride = fn(string $date, float $km, int $b = 0) => Db::insert('rides', ['user_id' => $uid, 'bike_id' => $b ?: $bike, 'ride_date' => $date,
    'distance_km' => $km, 'duration_s' => 3600, 'kind' => 'OUTDOOR', 'created_at' => $now, 'updated_at' => $now]);
$log = fn(string $code, int $cid, string $on, array $more = []) => Domain::logMaintenance($uid, $more + ['action_code' => $code, 'component_id' => $cid, 'bike_id' => null,
    'performed_on' => $on, 'outcome' => null, 'measurement_value' => null, 'consumable_id' => null, 'consumable_qty' => null, 'cost_cents' => null, 'shop' => null, 'notes' => null]);

$a = $part('CHAIN', 'Chain A');
$b = $part('CHAIN', 'Chain B');
Domain::install($uid, $a, $bike, null, 'CHAIN', '2026-09-01');
$ride('2026-09-05', 100);
$log('LUBE', $a, '2026-09-06');
$ride('2026-09-07', 50);
Workshop::replace($uid, $a, '2026-09-08', 'spare:' . $b, [], 'STORED', [], 'rotation');
$log('CHAIN_MEASURE_WEAR', $a, '2026-09-09', ['measurement_value' => 0.25]);
$ride('2026-09-10', 30);
Journal::add($uid, ['bike_id' => $bike, 'entry_on' => '2026-09-11', 'kind' => 'ISSUE', 'text' => 'Creak from the bottom bracket']);
$wrong = $log('LUBE', $b, '2026-09-12');
Domain::voidMaintenance($uid, $wrong, 'wrong chain');

$t = Timeline::forBike($uid, $bike);
$rows = $t['rows'];
$find = fn(array $rows, callable $f) => array_values(array_filter($rows, $f))[0] ?? null;
$lube = $find($rows, fn($r) => $r['type'] === 'LUBE');
check($lube && $lube['kind'] === 'WORK' && $lube['bike_km'] == 100 && $lube['part_km'] == 100 && $lube['part_km_status'] === 'KNOWN', 'bike timeline: lube at 100 km (bike and chain)');
check($lube['bike_km_status'] === 'MINIMUM', 'a bike has no starting odometer here: its km are a minimum');
$swap = $find($rows, fn($r) => $r['type'] === 'REPLACED');
check($swap && $swap['bike_km'] == 150 && str_contains($swap['detail'], 'Chain A off at 150 km'), 'the chain swap is one "Replaced" row with the old chain\'s km');
check(!$find($rows, fn($r) => $r['type'] === 'REMOVED'), 'no separate "Removed" row for a replacement');
check(!$find($rows, fn($r) => $r['type'] === 'CHAIN_MEASURE_WEAR'), 'work on the chain after it came off is not on this bike');
check($find($rows, fn($r) => $r['kind'] === 'NOTE')['bike_km'] == 180, 'the issue shows the bike km of that day');
check(!$find($rows, fn($r) => $r['voided']) && $t['voided_count'] === 1, 'deleted entries are hidden by default and counted');
$tv = Timeline::forBike($uid, $bike, ['voided' => true]);
check(($find($tv['rows'], fn($r) => $r['voided'])['void_reason'] ?? '') === 'wrong chain', 'deleted entries come back with the reason when asked');
$rowsDesc = array_column($rows, 'date');
$sorted = $rowsDesc;
rsort($sorted);
check($rowsDesc === $sorted, 'newest first');

Domain::install($uid, $a, $bike2, null, 'CHAIN', '2026-09-15');
$ride('2026-09-16', 40, $bike2);
$log('LUBE', $a, '2026-09-17');
$p = Timeline::forComponent($uid, $a);
$lubes = array_values(array_filter($p['rows'], fn($r) => $r['type'] === 'LUBE'));
usort($lubes, fn($x, $y) => strcmp($x['date'], $y['date']));
check(array_map(fn($r) => (float)$r['part_km'], $lubes) === [100.0, 190.0], 'part timeline: its own km across bikes (150 on one, 40 on the other)');
check($lubes[1]['bike'] === 'BMC', 'the part timeline names the bike it was on');
$wear = $find($p['rows'], fn($r) => $r['type'] === 'CHAIN_MEASURE_WEAR');
check($wear && $wear['kind'] === 'CHECK' && $wear['part_km'] == 150, 'a measurement is a check, at the chain\'s km then');

// same-day km: an entry with a date only counts from the start of the day
$ride('2026-09-20', 70, $bike2);
$log('LUBE', $a, '2026-09-20');
$late = $find(Timeline::forComponent($uid, $a)['rows'], fn($r) => $r['type'] === 'LUBE' && $r['date'] === '2026-09-20');
check($late['part_km'] == 190 && $late['same_day_km'] == 70, 'same-day km are given apart (+ up to 70 km that day)');

// filters
$only = Timeline::forBike($uid, $bike, ['kinds' => ['PARTS']]);
check($only['rows'] && !array_filter($only['rows'], fn($r) => $r['kind'] !== 'PARTS'), 'type filter');
$range = Timeline::forBike($uid, $bike, ['from' => '2026-09-06', 'to' => '2026-09-08']);
check(!array_filter($range['rows'], fn($r) => $r['date'] < '2026-09-06' || $r['date'] > '2026-09-08'), 'date filter');
check_throws(fn() => Timeline::forBike($uid, $bike, ['from' => '2026-09-09', 'to' => '2026-09-01']), 'start after end is refused');
check_throws(fn() => Timeline::forBike($uid, $bike, ['kinds' => ['NOPE']]), 'unknown entry type is refused');
check_throws(fn() => Timeline::forBike($uid + 999, $bike), 'another user cannot read the timeline');

// CSV
$csv = Timeline::csv($t, 'excel');
check(str_starts_with($csv, "\u{FEFF}date;date_only;kind"), 'CSV: UTF-8 BOM, semicolons for Excel');
$lines = array_map(fn($l) => str_getcsv($l, ';', '"', ''), array_filter(explode("\r\n", substr($csv, 3))));
$lubeLine = array_values(array_filter($lines, fn($l) => ($l[3] ?? '') === 'LUBE'))[0];
check($lubeLine[13] === '100,0' && $lubeLine[22] === 'maintenance_event:' . Db::value('SELECT id FROM maintenance_events WHERE user_id = ? AND action_code = ? ORDER BY id LIMIT 1', [$uid, 'LUBE']),
    'CSV: decimal comma and stable record id');
check(count($lines) === count($t['rows']) + 1 && $lines[1][0] <= $lines[count($lines) - 1][0], 'CSV: one line per entry, oldest first');
check(str_contains(Timeline::csv($t, 'standard'), ',100.0,'), 'CSV for other tools: comma and decimal point');
check(Timeline::csvFilename($t) === 'bikelog-timeline-TIME-NXR.csv', 'CSV file name');
