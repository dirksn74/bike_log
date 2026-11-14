<?php
declare(strict_types=1);

// Existing data is production data (docs/PROJECT_GUIDE_FOR_AI_AGENTS.md): data written by an OLDER version must
// keep working after an upgrade.
//  * A database of an older version (fixtures/db-005.sql, written by commit 181ce22's own code) upgrades with
//    the current migrations without losing a row; the app works on it (tests/upgrade/db_child.php, own database).
//  * A data file downloaded from an older version (fixtures/export-005.json) restores, upgraded to the current
//    schema; restoring it twice gives the same result; a file from a newer version is refused.

// ------------------------------------------------------------------ old data file
$file = UserBackups::parse((string)file_get_contents(__DIR__ . '/fixtures/export-005.json'));
check(!isset($file['schema']) && UserBackups::schemaOf($file) === UserBackups::OLDEST_FILE_SCHEMA, 'old file has no schema: treated as the oldest with backups');
$now = now_utc();
$uid = Db::insert('users', ['email' => 'oldfile@example.test', 'display_name' => 'O', 'password_hash' => Auth::hash('old-file-tester-pw'), 'role' => 'USER',
    'status' => 'ACTIVE', 'email_verified_at' => $now, 'timezone' => 'Europe/Berlin', 'created_at' => $now, 'updated_at' => $now]);
Domain::seedUser($uid);
$rowsOf = function (int $uid): array {
    $out = [];
    foreach (array_keys(UserBackups::TABLES) as $t) {
        $out[$t] = (int)Db::value("SELECT COUNT(*) FROM $t WHERE user_id = ?", [$uid]);
    }
    unset($out['change_log']);
    return $out;
};
$res = UserBackups::restore($uid, $file, 'old file');
check($res['upgraded'] === true && $res['from_schema'] === UserBackups::OLDEST_FILE_SCHEMA, 'old file restored and upgraded');
$expected = [];
foreach (array_keys(UserBackups::TABLES) as $t) {
    $expected[$t] = count($file[$t] ?? []);
}
unset($expected['change_log']);
check($rowsOf($uid) === $expected, 'every row of the old file is restored');
$km1 = array_map(fn($c) => Domain::totals($uid, $c)['total_km'], Db::all('SELECT * FROM components WHERE user_id = ? ORDER BY label, id', [$uid]));
UserBackups::restore($uid, $file, 'old file again');
$km2 = array_map(fn($c) => Domain::totals($uid, $c)['total_km'], Db::all('SELECT * FROM components WHERE user_id = ? ORDER BY label, id', [$uid]));
check($rowsOf($uid) === $expected && $km1 === $km2 && array_sum($km1) > 0, 'restoring the same file twice gives the same result');

$new = UserBackups::export($uid);
check($new['version'] === UserBackups::VERSION && $new['schema'] === Migrator::latest() && Migrator::current() === Migrator::latest(), 'a new file names the current schema');
check_throws(fn() => UserBackups::parse(json_encode([...$new, 'schema' => '999_from_the_future'])), 'file from a newer schema refused', 'newer');
check_throws(fn() => UserBackups::parse(json_encode([...$new, 'schema' => '../x'])), 'odd schema refused', 'not a Bike Log data file');

// the web page: restore the old file by upload; the message says it was upgraded
$b = new Browser($base);
$b->post('r=login', ['email' => 'oldfile@example.test', 'password' => 'old-file-tester-pw']);
$b->upload('r=backups', ['do' => 'upload', 'confirm' => UserBackups::CONFIRM_RESTORE], ['file' => [['old.json', (string)file_get_contents(__DIR__ . '/fixtures/export-005.json')]]]);
check(str_contains($b->body, 'older version of Bike Log'), 'restore page says the old file was brought up to date');
check($rowsOf($uid) === $expected, 'upload restore of the old file: same rows');

// ------------------------------------------------------------------ old database, upgraded by the migrations
$upName = $cfg['db']['name'] . '_upgrade';
$pdo->exec("DROP DATABASE IF EXISTS `$upName`");
$pdo->exec("CREATE DATABASE `$upName` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
$upCfg = $cfg;
$upCfg['db']['name'] = $upName;
$upCfgFile = "$tmp/config-upgrade.php";
file_put_contents($upCfgFile, '<?php return ' . var_export($upCfg, true) . ';');
$cmd = sprintf('BIKELOG_CONFIG=%s php %s %s %s 2>&1', escapeshellarg($upCfgFile), escapeshellarg(__DIR__ . '/upgrade/db_child.php'),
    escapeshellarg(__DIR__ . '/fixtures/db-005.sql'), escapeshellarg('005_lists_changelog_backups'));
$raw = (string)shell_exec($cmd);
$results = json_decode($raw, true);
check(is_array($results), 'upgrade check ran: ' . substr($raw, 0, 500));
foreach (is_array($results) ? $results : [] as [$ok, $what]) {
    check((bool)$ok, "old database: $what");
}
$pdo->exec("DROP DATABASE IF EXISTS `$upName`");
@unlink($upCfgFile);
