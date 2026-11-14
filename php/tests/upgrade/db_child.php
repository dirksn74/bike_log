<?php
declare(strict_types=1);

// Runs in its own process with its own (empty) test database, started by tests/test_96_upgrade.php.
// Builds the database a user of an OLDER Bike Log has: the migrations up to that version, then that version's
// data (fixtures/db-005.sql, written by commit 181ce22's own code). Then it upgrades it exactly as the app
// does (Migrator::migrate) and checks that nothing was lost and that the app works on it. Prints JSON.
//
//   BIKELOG_CONFIG=<config of a *test* database> php tests/upgrade/db_child.php <fixture.sql> <last old migration>

$root = dirname(__DIR__, 2);
require $root . '/app/bootstrap.php';

[$_, $fixture, $oldSchema] = $argv;
$out = [];
$check = function (bool $ok, string $what) use (&$out) {
    $out[] = [$ok, $what];
};

// ------------------------------------------------------------------ the old database
$pdo = Db::pdo();
$pdo->exec('CREATE TABLE IF NOT EXISTS schema_migrations (version VARCHAR(64) PRIMARY KEY, applied_at DATETIME NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
foreach (Migrator::pending() as $v => $file) {
    if (strcmp($v, $oldSchema) > 0) {
        break;
    }
    foreach (Migrator::statements((string)file_get_contents($file)) as $sql) {
        $pdo->exec($sql);
    }
    Db::insert('schema_migrations', ['version' => $v, 'applied_at' => now_utc()]);
}
$check(Migrator::current() === $oldSchema, "database built at schema $oldSchema");
$pdo->exec('SET FOREIGN_KEY_CHECKS = 0');
foreach (preg_split('/\R/', (string)file_get_contents($fixture)) as $line) {
    if (str_starts_with($line, 'INSERT')) {
        $pdo->exec($line);
    }
}
$pdo->exec('SET FOREIGN_KEY_CHECKS = 1');

$tables = fn() => Db::run('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN);
$snapshot = function () use ($tables) {
    $s = [];
    foreach ($tables() as $t) {
        if ($t === 'schema_migrations') {
            continue;
        }
        $pk = array_column(Db::all("SHOW KEYS FROM `$t` WHERE Key_name = 'PRIMARY'"), 'Column_name');
        $key = 'CONCAT_WS(\'|\', ' . implode(', ', array_map(fn($c) => "`$c`", $pk)) . ')';
        $s[$t] = Db::run("SELECT $key FROM `$t` ORDER BY 1")->fetchAll(PDO::FETCH_COLUMN);
    }
    return $s;
};
$before = $snapshot();
$check(count($before['components'] ?? []) > 20 && count($before['rides'] ?? []) > 10, 'old database has data');
$users = Db::run('SELECT id FROM users ORDER BY id')->fetchAll(PDO::FETCH_COLUMN);

// ------------------------------------------------------------------ upgrade, as the app does
$applied = Migrator::migrate();
$check($applied !== [] && Migrator::current() === Migrator::latest(), 'upgraded to ' . Migrator::latest() . ' (applied ' . implode(', ', $applied) . ')');
$after = $snapshot();
foreach ($before as $t => $ids) {
    $lost = array_diff($ids, $after[$t] ?? []);
    $check(isset($after[$t]) && $lost === [], "$t: all " . count($ids) . ' rows kept' . ($lost ? ' (lost ids ' . implode(',', array_slice($lost, 0, 5)) . ')' : ''));
}
foreach ($users as $uid) {
    foreach (UserBackups::TABLES as $t => $refs) {
        foreach ($refs as $col => $target) {
            $n = (int)Db::value("SELECT COUNT(*) FROM $t x WHERE x.user_id = ? AND x.$col IS NOT NULL
                AND NOT EXISTS (SELECT 1 FROM $target y WHERE y.id = x.$col AND y.user_id = ?)", [$uid, $uid]);
            if ($n && !in_array("$t.$col", ['components.from_stock_txn_id', 'pick_list_items.merged_into_id', 'change_log.bike_id', 'change_log.component_id'], true)) {
                $check(false, "user $uid: $t.$col has $n broken references");
            }
        }
    }
}

// ------------------------------------------------------------------ the app works on the upgraded data
$errors = [];
$km = [];
foreach ($users as $uid) {
    try {
        foreach (Db::all('SELECT * FROM components WHERE user_id = ? ORDER BY id', [$uid]) as $c) {
            $km[$uid][] = Domain::totals((int)$uid, $c)['total_km'];
        }
        foreach (Db::all('SELECT id FROM bikes WHERE user_id = ?', [$uid]) as $b) {
            Costs::bike((int)$uid, (int)$b['id']);
        }
        Reminders::forUser((int)$uid);
    } catch (Throwable $e) {
        $errors[] = "user $uid: " . $e->getMessage();
    }
}
$check($errors === [], 'parts, costs and reminders work for every user' . ($errors ? ': ' . implode('; ', array_slice($errors, 0, 3)) : ''));

// export from the upgraded database and restore it into a new account: same data
$rich = (int)Db::value('SELECT user_id FROM components GROUP BY user_id ORDER BY COUNT(*) DESC LIMIT 1');
$doc = json_decode(UserBackups::encode(UserBackups::export($rich)), true);
$check($doc['schema'] === Migrator::latest() && $doc['version'] === UserBackups::VERSION, 'export names the current schema');
$now = now_utc();
$copy = Db::insert('users', ['email' => 'upgrade-copy@example.test', 'display_name' => 'C', 'password_hash' => Auth::hash('upgrade-copy-pw'), 'role' => 'USER',
    'status' => 'ACTIVE', 'email_verified_at' => $now, 'timezone' => 'Europe/Berlin', 'created_at' => $now, 'updated_at' => $now]);
Domain::seedUser($copy);
UserBackups::restore($copy, $doc, 'test');
$kmCopy = array_map(fn($c) => Domain::totals($copy, $c)['total_km'], Db::all('SELECT * FROM components WHERE user_id = ? ORDER BY id', [$copy]));
$check($kmCopy === $km[$rich], 'km per part the same after export + restore of upgraded data');

// a copy stored by the old version (user_backups) can still be restored
$old = Db::one('SELECT id, user_id FROM user_backups ORDER BY id LIMIT 1');
if ($old) {
    $res = UserBackups::restore((int)$old['user_id'], UserBackups::parse(UserBackups::content((int)$old['user_id'], (int)$old['id'])), 'old copy');
    $check($res['upgraded'] === true && $res['from_schema'] === UserBackups::OLDEST_FILE_SCHEMA, 'a copy stored by the old version restores and is upgraded');
} else {
    $check(false, 'fixture has a stored copy');
}

echo json_encode($out);
