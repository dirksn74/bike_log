<?php
declare(strict_types=1);

// Timeline of a bike or a part (same idea as the desktop app's services/timeline.py, DECISIONS 142):
// everything that happened to it, newest first, with the km at that moment. Built from the existing records
// (maintenance, installations, journal and incidents, km corrections, what happened to a part off the bike,
// purchase); nothing new is stored. Deleted / corrected records come back with 'voided' set.
//
// Km at an entry (dates only here, so an entry means the START of its day, like installations):
// - bike: km of the bike's counted rides before that day. A bike has no starting odometer in this version,
//   so it is a minimum (≥).
// - part: its own lifetime km before that day across every bike (Domain::rideUsage with $until), plus the
//   km before tracking and corrections up to that day. Status: KNOWN, ESTIMATED (≈), MINIMUM (≥).
// 'same_day_km' = km ridden on that day (the entry may have been after them).

final class Timeline
{
    public const KINDS = [
        'WORK' => 'Work done',
        'CHECK' => 'Checks and measurements',
        'PARTS' => 'Parts on and off',
        'INCIDENT' => 'Incidents',
        'NOTE' => 'Notes and issues',
        'OTHER' => 'Km and status',
    ];

    public const CSV_COLUMNS = ['date', 'date_only', 'kind', 'type', 'title', 'detail', 'bike', 'bike_id', 'part', 'part_id', 'part_type',
        'other_part', 'other_part_id', 'bike_km', 'bike_km_status', 'part_km', 'part_km_status', 'same_day_km', 'cost', 'voided', 'void_reason',
        'ride_id', 'record'];

    private array $rows = [];
    private array $labels = [];
    private array $types = [];
    private array $bikes = [];
    private array $kmCache = [];

    private function __construct(private int $uid, private ?array $bike, private ?array $comp)
    {
        foreach (Db::all('SELECT id, label, mark, component_type FROM components WHERE user_id = ?', [$uid]) as $c) {
            $this->labels[(int)$c['id']] = Domain::componentName($c);
            $this->types[(int)$c['id']] = $c['component_type'];
        }
        foreach (Db::all('SELECT id, name FROM bikes WHERE user_id = ?', [$uid]) as $b) {
            $this->bikes[(int)$b['id']] = $b['name'];
        }
    }

    // ------------------------------------------------------------------ km at the start of a day

    /** [km, status] of a bike's counted rides before $day. */
    private function bikeKmAt(int $bikeId, string $day): array
    {
        $key = "b$bikeId|$day";
        if (!isset($this->kmCache[$key])) {
            $r = Db::one('SELECT COALESCE(SUM(r.distance_km),0) km FROM rides r WHERE r.user_id = ? AND r.bike_id = ? AND r.ride_date < ? AND ' . Domain::COUNTED,
                [$this->uid, $bikeId, $day]);
            $this->kmCache[$key] = [round((float)$r['km'], 1), 'MINIMUM'];
        }
        return $this->kmCache[$key];
    }

    private function bikeKmOnDay(int $bikeId, string $day): float
    {
        return (float)Db::value('SELECT COALESCE(SUM(r.distance_km),0) FROM rides r WHERE r.user_id = ? AND r.bike_id = ? AND r.ride_date = ? AND ' . Domain::COUNTED,
            [$this->uid, $bikeId, $day]);
    }

    /** [km, status] of a part before $day: starting km + corrections up to that day + rides before it. */
    private function partKmAt(int $cid, string $day): array
    {
        $key = "p$cid|$day";
        if (!isset($this->kmCache[$key])) {
            $c = Domain::component($this->uid, $cid);
            $rides = Domain::rideUsage($this->uid, $c, null, $day);
            $adj = Db::one('SELECT COALESCE(SUM(km),0) km, COALESCE(MAX(is_estimate),0) est FROM usage_adjustments
                WHERE user_id = ? AND component_id = ? AND voided_at IS NULL AND effective_on <= ?', [$this->uid, $cid, $day]);
            $start = $c['prior_usage'] === 'RECORDED' ? (float)$c['starting_km'] : 0.0;
            $status = 'KNOWN';
            if ($c['prior_usage'] === 'UNKNOWN' || $rides['missing_distance']) {
                $status = 'MINIMUM';
            } elseif (($c['prior_usage'] === 'RECORDED' && $c['starting_km_estimate']) || $adj['est']) {
                $status = 'ESTIMATED';
            }
            $this->kmCache[$key] = [round($start + $rides['km'] + (float)$adj['km'], 1), $status];
        }
        return $this->kmCache[$key];
    }

    private function partKmOnDay(int $cid, string $day): float
    {
        $next = (new DateTimeImmutable($day))->modify('+1 day')->format('Y-m-d');
        return Domain::rideUsage($this->uid, Domain::component($this->uid, $cid), $day, $next)['km'];
    }

    // ------------------------------------------------------------------ rows

    private function add(array $r): void
    {
        $r += ['detail' => null, 'bike_id' => null, 'component_id' => null, 'other_component_id' => null, 'cost_cents' => null,
            'voided' => false, 'void_reason' => null, 'ride_id' => null, 'group' => null];
        $r['bike'] = $r['bike_id'] ? ($this->bikes[(int)$r['bike_id']] ?? null) : null;
        $r['component'] = $r['component_id'] ? ($this->labels[(int)$r['component_id']] ?? null) : null;
        $r['component_type'] = $r['component_id'] ? ($this->types[(int)$r['component_id']] ?? null) : null;
        $r['other_component'] = $r['other_component_id'] ? ($this->labels[(int)$r['other_component_id']] ?? null) : null;
        $r['bike_km'] = $r['bike_km_status'] = $r['part_km'] = $r['part_km_status'] = null;
        $sameDay = 0.0;
        $odoBike = $this->bike ? (int)$this->bike['id'] : ($r['bike_id'] ? (int)$r['bike_id'] : null);
        if ($odoBike) {
            [$r['bike_km'], $r['bike_km_status']] = $this->bikeKmAt($odoBike, $r['date']);
            $sameDay = $this->bikeKmOnDay($odoBike, $r['date']);
        }
        $part = $this->comp ? (int)$this->comp['id'] : ($r['component_id'] ? (int)$r['component_id'] : null);
        if ($part) {
            [$r['part_km'], $r['part_km_status']] = $this->partKmAt($part, $r['date']);
            $sameDay = max($sameDay, $this->partKmOnDay($part, $r['date']));
        }
        $r['same_day_km'] = $sameDay > 0 ? round($sameDay, 1) : null;
        $this->rows[] = $r;
    }

    private static function eventKind(string $code): string
    {
        $kind = Catalog::action($code)['kind'] ?? '';
        return in_array($kind, ['INSPECT', 'MEASURE'], true) ? 'CHECK' : ($kind === 'NOTE' ? 'NOTE' : 'WORK');
    }

    private function addEvents(string $where, array $args): void
    {
        $rows = Db::all("SELECT e.*, s.name AS consumable_name, s.unit AS consumable_unit FROM maintenance_events e
            LEFT JOIN consumables s ON s.id = e.consumable_id WHERE e.user_id = ? AND $where", array_merge([$this->uid], $args));
        foreach ($rows as $e) {
            $bits = [];
            if ($e['measurement_value'] !== null) {
                $bits[] = trim(num((float)$e['measurement_value'], 2) . ' ' . ($e['measurement_unit'] ?? ''));
            }
            if ($e['outcome']) {
                $bits[] = Catalog::label($e['outcome']);
            }
            if ($e['consumable_id']) {
                $bits[] = $e['consumable_qty'] !== null
                    ? t('used {qty} {unit} {name}', ['qty' => num((float)$e['consumable_qty'], 1), 'unit' => $e['consumable_unit'], 'name' => $e['consumable_name']])
                    : t('used {name}', ['name' => $e['consumable_name']]);
            }
            if (!empty($e['symptom'])) {
                $bits[] = t('Symptom: {text}', ['text' => $e['symptom']]);
            }
            if (!empty($e['work_done'])) {
                $bits[] = t('Work done: {text}', ['text' => $e['work_done']]);
            }
            if ($e['shop']) {
                $bits[] = t('at {shop}', ['shop' => $e['shop']]);
            }
            if ($e['notes']) {
                $bits[] = $e['notes'];
            }
            $this->add(['ref' => 'maintenance_event:' . $e['id'], 'kind' => self::eventKind($e['action_code']), 'type' => $e['action_code'],
                'title' => Catalog::actionName($e['action_code']), 'date' => $e['performed_on'], 'bike_id' => $e['bike_id'],
                'component_id' => $e['component_id'], 'detail' => implode(' · ', $bits), 'cost_cents' => $e['cost_cents'] !== null ? (int)$e['cost_cents'] : null,
                'voided' => $e['voided_at'] !== null, 'void_reason' => $e['void_reason'],
                'group' => $e['work_session_id'] ? 'ws:' . $e['work_session_id'] : null]);
        }
    }

    /** The bike a part was on (directly or via its parents) on a day; $atEnd: the day it came off counts too. */
    private function rootBike(int $cid, string $day, bool $atEnd = false, int $depth = 0): ?int
    {
        if ($depth > 6) {
            return null;
        }
        foreach (Db::all('SELECT * FROM installations WHERE user_id = ? AND component_id = ? AND voided_at IS NULL', [$this->uid, $cid]) as $i) {
            $endOk = $i['removed_on'] === null || ($atEnd ? $i['removed_on'] >= $day : $i['removed_on'] > $day);
            if ($i['installed_on'] <= $day && $endOk) {
                return $i['bike_id'] !== null ? (int)$i['bike_id'] : $this->rootBike((int)$i['parent_component_id'], $day, $atEnd, $depth + 1);
            }
        }
        return null;
    }

    private function where(array $i): string
    {
        $target = $i['bike_id'] ? ($this->bikes[(int)$i['bike_id']] ?? '') : ($this->labels[(int)$i['parent_component_id']] ?? '');
        return $target . ' · ' . Catalog::slotName($i['slot']);
    }

    /** On / off rows; with $merge a part off and another on in the same place on the same day is one "Replaced" row. */
    private function addInstallations(array $installs, bool $merge, ?callable $keep = null): void
    {
        $removed = [];
        if ($merge) {
            foreach ($installs as $i) {
                if ($i['removed_on'] && !$i['voided_at']) {
                    $removed[$i['bike_id'] . '|' . $i['parent_component_id'] . '|' . $i['slot'] . '|' . $i['removed_on']] = $i;
                }
            }
        }
        $merged = [];
        foreach ($installs as $i) {
            $bikeOf = $i['bike_id'] ? (int)$i['bike_id'] : ($this->bike ? (int)$this->bike['id'] : $this->rootBike((int)$i['parent_component_id'], $i['installed_on']));
            $group = $i['work_session_id'] ? 'ws:' . $i['work_session_id'] : null;
            $old = !$i['voided_at'] ? ($removed[$i['bike_id'] . '|' . $i['parent_component_id'] . '|' . $i['slot'] . '|' . $i['installed_on']] ?? null) : null;
            if ($old && $old['id'] !== $i['id'] && (!$keep || $keep($i, 'INSTALLED'))) {
                $merged[$old['id']] = true;
                [$okm, $ost] = $this->partKmAt((int)$old['component_id'], $old['removed_on']);
                $detail = t('{part} off at {km}', ['part' => $this->labels[(int)$old['component_id']] ?? '', 'km' => self::kmText($okm, $ost)])
                    . ($old['removal_reason'] ? ' (' . $old['removal_reason'] . ')' : '');
                $this->add(['ref' => 'installation:' . $i['id'], 'kind' => 'PARTS', 'type' => 'REPLACED',
                    'title' => t('Replaced: {old} → {new}', ['old' => $this->labels[(int)$old['component_id']] ?? '', 'new' => $this->labels[(int)$i['component_id']] ?? '']),
                    'date' => $i['installed_on'], 'bike_id' => $bikeOf, 'component_id' => $i['component_id'], 'other_component_id' => $old['component_id'],
                    'detail' => $this->where($i) . ' · ' . $detail, 'group' => $group]);
                continue;
            }
            if ($keep && !$keep($i, 'INSTALLED')) {
                continue;
            }
            $this->add(['ref' => 'installation:' . $i['id'], 'kind' => 'PARTS', 'type' => 'INSTALLED',
                'title' => t('Installed: {part}', ['part' => $this->labels[(int)$i['component_id']] ?? '']), 'date' => $i['installed_on'],
                'bike_id' => $bikeOf, 'component_id' => $i['component_id'], 'detail' => implode(' · ', array_filter([$this->where($i), $i['note']])),
                'voided' => $i['voided_at'] !== null, 'void_reason' => $i['void_reason'], 'group' => $group]);
        }
        foreach ($installs as $i) {
            if (!$i['removed_on'] || isset($merged[$i['id']]) || ($keep && !$keep($i, 'REMOVED'))) {
                continue;
            }
            $bikeOf = $i['bike_id'] ? (int)$i['bike_id'] : ($this->bike ? (int)$this->bike['id'] : $this->rootBike((int)$i['parent_component_id'], $i['removed_on'], true));
            $outcome = $i['removal_outcome'] ? ($i['removal_outcome'] === 'MOVED' ? t('moved') : lc(Catalog::raw('dispositions')[$i['removal_outcome']] ?? $i['removal_outcome'])) : null;
            $this->add(['ref' => 'installation:' . $i['id'] . ':removed', 'kind' => 'PARTS', 'type' => 'REMOVED',
                'title' => t('Removed: {part}', ['part' => $this->labels[(int)$i['component_id']] ?? '']), 'date' => $i['removed_on'],
                'bike_id' => $bikeOf, 'component_id' => $i['component_id'],
                'detail' => implode(' · ', array_filter([$this->where($i), $outcome, $i['removal_reason']])),
                'voided' => $i['voided_at'] !== null, 'void_reason' => $i['void_reason'],
                'group' => $i['removal_session_id'] ? 'ws:' . $i['removal_session_id'] : null]);
        }
    }

    private function addJournal(string $where, array $args): void
    {
        $types = Catalog::raw('incident_types');
        $groups = [];
        foreach (Db::all("SELECT * FROM journal_entries WHERE user_id = ? AND $where ORDER BY id", array_merge([$this->uid], $args)) as $e) {
            if ($e['incident_type'] && $e['incident_group']) {
                $groups[$e['incident_group']][] = $e;
                continue;
            }
            $state = $e['resolved_on'] ? t('solved {date}', ['date' => $e['resolved_on']]) : ($e['kind'] === 'ISSUE' ? t('open') : null);
            $this->add(['ref' => 'journal_entry:' . $e['id'], 'kind' => $e['incident_type'] ? 'INCIDENT' : 'NOTE', 'type' => $e['incident_type'] ?: $e['kind'],
                'title' => $e['incident_type'] ? ($types[$e['incident_type']] ?? $e['incident_type']) : ($e['kind'] === 'ISSUE' ? t('Issue') : t('Note')),
                'date' => $e['entry_on'], 'bike_id' => $e['bike_id'], 'component_id' => $e['component_id'],
                'detail' => implode(' · ', array_filter([$e['text'], $e['affected'], $state])),
                'voided' => $e['voided_at'] !== null, 'void_reason' => $e['void_reason'], 'ride_id' => $e['ride_id']]);
        }
        foreach ($groups as $gid => $entries) {
            $first = $entries[0];
            $live = array_values(array_filter($entries, fn($x) => $x['voided_at'] === null)) ?: $entries;
            $affected = implode(', ', array_unique(array_map(fn($x) => $x['component_id'] ? ($this->labels[(int)$x['component_id']] ?? '') : ($x['affected'] ?: t('whole bike')), $live)));
            $fixes = [];
            foreach ($live as $x) {
                if ($x['repair'] && $x['repair'] !== 'NONE') {
                    $fixes[] = ($x['component_id'] ? ($this->labels[(int)$x['component_id']] ?? '') : ($x['affected'] ?: t('bike'))) . ': ' . Catalog::label($x['repair'])
                        . ($x['repair_text'] ? ' (' . $x['repair_text'] . ')' : '');
                }
            }
            $resolved = null;
            foreach ($live as $x) {
                $resolved ??= $x['resolved_on'];
            }
            $allVoided = count(array_filter($entries, fn($x) => $x['voided_at'] === null)) === 0;
            $this->add(['ref' => 'incident:' . $gid, 'kind' => 'INCIDENT', 'type' => $first['incident_type'],
                'title' => $types[$first['incident_type']] ?? $first['incident_type'], 'date' => $first['entry_on'], 'bike_id' => $first['bike_id'],
                'component_id' => $this->comp ? (int)$this->comp['id'] : (count($live) === 1 ? $live[0]['component_id'] : null),
                'detail' => implode(' · ', array_filter([$affected !== '' ? t('affected: {what}', ['what' => $affected]) : null, $first['text'],
                    $fixes ? implode('; ', $fixes) : null, $resolved ? t('solved {date}', ['date' => $resolved]) : t('open')])),
                'voided' => $allVoided, 'void_reason' => $first['void_reason'], 'ride_id' => $first['ride_id']]);
        }
    }

    // ------------------------------------------------------------------ public

    public static function forBike(int $uid, int $bikeId, array $f = []): array
    {
        self::checkFilter($f);
        $bike = Domain::bike($uid, $bikeId);
        $t = new self($uid, $bike, null);
        if ($bike['purchase_date']) {
            $t->add(['ref' => 'bike:' . $bike['id'] . ':bought', 'kind' => 'OTHER', 'type' => 'BOUGHT', 'title' => t('Bike bought'),
                'date' => $bike['purchase_date'], 'bike_id' => $bike['id'], 'cost_cents' => $bike['purchase_price_cents'] !== null ? (int)$bike['purchase_price_cents'] : null]);
        }
        $t->addEvents('e.bike_id = ?', [$bikeId]);
        $t->addInstallations(Db::all('SELECT * FROM installations WHERE user_id = ? AND bike_id = ?', [$uid, $bikeId]), true);
        // parts put on / taken off a part while that part was on this bike (a tire on a wheel)
        $nested = Db::all('SELECT * FROM installations WHERE user_id = ? AND parent_component_id IS NOT NULL', [$uid]);
        $halves = [];
        foreach ($nested as $i) {
            $halves[$i['id']] = [
                'INSTALLED' => $t->rootBike((int)$i['parent_component_id'], $i['installed_on']) === $bikeId,
                'REMOVED' => $i['removed_on'] !== null && $t->rootBike((int)$i['parent_component_id'], $i['removed_on'], true) === $bikeId,
            ];
        }
        $nested = array_values(array_filter($nested, fn($i) => $halves[$i['id']]['INSTALLED'] || $halves[$i['id']]['REMOVED']));
        $t->addInstallations($nested, true, fn($i, $half) => $halves[$i['id']][$half]);
        $t->addJournal('bike_id = ?', [$bikeId]);
        return $t->result($f, ['subject' => 'BIKE', 'bike_id' => $bikeId, 'name' => $bike['name']]);
    }

    public static function forComponent(int $uid, int $componentId, array $f = []): array
    {
        self::checkFilter($f);
        $c = Domain::component($uid, $componentId);
        $t = new self($uid, null, $c);
        if ($c['purchase_date']) {
            $t->add(['ref' => 'component:' . $c['id'] . ':bought', 'kind' => 'OTHER', 'type' => 'BOUGHT', 'title' => t('Bought'),
                'date' => $c['purchase_date'], 'component_id' => $c['id'], 'cost_cents' => $c['price_cents'] !== null ? (int)$c['price_cents'] : null,
                'detail' => $c['shop'] ? t('at {shop}', ['shop' => $c['shop']]) : null]);
        }
        $t->addEvents('e.component_id = ?', [$componentId]);
        $installs = Db::all('SELECT * FROM installations WHERE user_id = ? AND component_id = ?', [$uid, $componentId]);
        $t->addInstallations($installs, false);
        $removalSessions = array_filter(array_map(fn($i) => $i['removal_session_id'], $installs));
        $removalDays = array_filter(array_map(fn($i) => $i['removed_on'], $installs));
        $labels = Catalog::raw('dispositions');
        foreach (Db::all('SELECT * FROM component_dispositions WHERE user_id = ? AND component_id = ?', [$uid, $componentId]) as $d) {
            if ($d['disposition'] === 'MOVED' || ($d['work_session_id'] && in_array($d['work_session_id'], $removalSessions))
                || (!$d['work_session_id'] && in_array($d['effective_on'], $removalDays, true))) {
                continue;   // the "Removed" row already says it
            }
            $t->add(['ref' => 'component_disposition:' . $d['id'], 'kind' => 'OTHER', 'type' => $d['disposition'],
                'title' => $labels[$d['disposition']] ?? $d['disposition'], 'date' => $d['effective_on'], 'component_id' => $componentId, 'detail' => $d['note']]);
        }
        $t->addJournal('component_id = ?', [$componentId]);
        foreach (Db::all('SELECT * FROM usage_adjustments WHERE user_id = ? AND component_id = ?', [$uid, $componentId]) as $a) {
            $t->add(['ref' => 'usage_adjustment:' . $a['id'], 'kind' => 'OTHER', 'type' => 'CORRECTION',
                'title' => t('Km correction: {km}', ['km' => ((float)$a['km'] >= 0 ? '+' : '') . km((float)$a['km'], 1)]), 'date' => $a['effective_on'],
                'component_id' => $componentId, 'detail' => $a['note'], 'voided' => $a['voided_at'] !== null,
                'void_reason' => $a['voided_at'] !== null ? t('removed') : null]);
        }
        return $t->result($f, ['subject' => 'COMPONENT', 'component_id' => $componentId, 'name' => Domain::componentName($c), 'component_type' => $c['component_type']]);
    }

    private static function checkFilter(array $f): void
    {
        foreach (['from', 'to'] as $k) {
            if (!empty($f[$k])) {
                parse_date((string)$f[$k]);
            }
        }
        if (!empty($f['from']) && !empty($f['to']) && $f['from'] > $f['to']) {
            throw new UserError(t('The start date is after the end date.'));
        }
        foreach ($f['kinds'] ?? [] as $k) {
            if (!isset(self::KINDS[$k])) {
                throw new UserError(t('Unknown entry type.'));
            }
        }
    }

    private function result(array $f, array $subject): array
    {
        $rows = $this->rows;
        usort($rows, fn($a, $b) => [$b['date'], $b['ref']] <=> [$a['date'], $a['ref']]);   // newest first
        $from = $f['from'] ?? null;
        $to = $f['to'] ?? null;
        $kinds = $f['kinds'] ?? [];
        $withVoided = !empty($f['voided']);
        $counts = array_fill_keys(array_keys(self::KINDS), 0);
        $voided = 0;
        $shown = [];
        foreach ($rows as $r) {
            if (($from && $r['date'] < $from) || ($to && $r['date'] > $to)) {
                continue;
            }
            if ($r['voided']) {
                $voided++;
                if (!$withVoided) {
                    continue;
                }
            }
            $counts[$r['kind']]++;
            if (!$kinds || in_array($r['kind'], $kinds, true)) {
                $shown[] = $r;
            }
        }
        return $subject + ['counts' => $counts, 'voided_count' => $voided, 'total' => count($rows), 'rows' => $shown];
    }

    public static function kmText(?float $v, ?string $status): string
    {
        if ($v === null || $status === 'MISSING') {
            return t('km unknown');
        }
        return (['ESTIMATED' => '≈', 'MINIMUM' => '≥'][$status] ?? '') . km($v);
    }

    /** CSV, oldest first. 'excel': semicolon and decimal comma (Excel on a German Windows); 'standard': comma, decimal point. UTF-8 with BOM. */
    public static function csv(array $result, string $style): string
    {
        [$sep, $dec] = $style === 'excel' ? [';', ','] : [',', '.'];
        $n = fn(?float $v, int $p = 1) => $v === null ? '' : str_replace('.', $dec, number_format($v, $p, '.', ''));
        $rows = $result['rows'];
        usort($rows, fn($a, $b) => [$a['date'], $a['ref']] <=> [$b['date'], $b['ref']]);
        $fh = fopen('php://temp', 'w+');
        fputcsv($fh, self::CSV_COLUMNS, $sep, '"', '', "\r\n");
        foreach ($rows as $r) {
            fputcsv($fh, [$r['date'], 'yes', t(self::KINDS[$r['kind']]), $r['type'], $r['title'], (string)$r['detail'], (string)$r['bike'], (string)$r['bike_id'],
                (string)$r['component'], (string)$r['component_id'], (string)$r['component_type'], (string)$r['other_component'], (string)$r['other_component_id'],
                $n($r['bike_km']), (string)$r['bike_km_status'], $n($r['part_km']), (string)$r['part_km_status'], $n($r['same_day_km']),
                $r['cost_cents'] === null ? '' : $n($r['cost_cents'] / 100, 2), $r['voided'] ? 'yes' : 'no', (string)$r['void_reason'],
                (string)$r['ride_id'], $r['ref']], $sep, '"', '', "\r\n");
        }
        rewind($fh);
        $out = stream_get_contents($fh);
        fclose($fh);
        return "\u{FEFF}" . $out;
    }

    public static function csvFilename(array $result): string
    {
        $name = trim((string)preg_replace('/[^A-Za-z0-9._-]+/', '-', $result['name']), '-');
        return 'bikelog-timeline-' . ($name !== '' ? $name : 'timeline') . '.csv';
    }
}
