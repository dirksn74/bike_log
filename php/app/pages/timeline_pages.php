<?php
declare(strict_types=1);

// Timeline of a bike (?r=timeline&bike=ID) or a part (?r=timeline&part=ID): list with filters, and the same
// list as CSV (&format=csv). Read-only (GET), so no CSRF token is needed.

function page_timeline(): void
{
    $uid = (int)require_user()['id'];
    $kinds = array_values(array_filter((array)($_GET['kinds'] ?? []), fn($k) => is_string($k) && $k !== ''));
    $f = ['from' => get_param('from'), 'to' => get_param('to'), 'kinds' => $kinds, 'voided' => get_param('voided') === '1'];
    $result = get_int('bike') ? Timeline::forBike($uid, get_int('bike'), $f) : Timeline::forComponent($uid, get_int('part'), $f);
    $style = get_param('style', I18n::lang() === 'de' ? 'excel' : 'standard');
    $style = in_array($style, ['excel', 'standard'], true) ? $style : 'standard';
    if (get_param('format') === 'csv') {
        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename="' . Timeline::csvFilename($result) . '"');
        echo Timeline::csv($result, $style);
        exit;
    }
    View::render('timeline/show', compact('result', 'f', 'style'), t('Timeline: {name}', ['name' => $result['name']]),
        $result['subject'] === 'BIKE' ? 'bikes' : 'parts');
}
