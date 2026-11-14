<?php
$onBike = $result['subject'] === 'BIKE';
$base = $onBike ? ['bike' => $result['bike_id']] : ['part' => $result['component_id']];
$query = $base + array_filter(['from' => $f['from'], 'to' => $f['to'], 'voided' => $f['voided'] ? '1' : '']) + ($f['kinds'] ? ['kinds' => $f['kinds']] : []);
$filtered = $f['from'] || $f['to'] || $f['kinds'] || $f['voided'];
?>
<p class="muted"><a href="<?= h($onBike ? url('bike', ['id' => $result['bike_id']]) : url('part', ['id' => $result['component_id']])) ?>">← <?= h($result['name']) ?></a></p>
<p class="muted"><?= h($onBike
    ? t('Everything done on this bike, newest first, with the bike’s km at that moment (and the part’s own km).')
    : t('Everything that happened to this part, newest first, with its own km at that moment (all bikes together).')) ?>
  <?= h(t('An entry counts from the start of its day. ≈ estimated, ≥ at least.')) ?></p>

<details<?= $filtered ? ' open' : '' ?>>
  <summary><?= h(t('Filter and CSV export')) ?></summary>
  <form method="get">
    <input type="hidden" name="r" value="timeline">
    <?php foreach ($base as $k => $v): ?><input type="hidden" name="<?= h($k) ?>" value="<?= (int)$v ?>"><?php endforeach; ?>
    <fieldset class="row">
      <?php foreach (Timeline::KINDS as $code => $label): ?>
        <label class="check"><input type="checkbox" name="kinds[]" value="<?= h($code) ?>"<?= in_array($code, $f['kinds'], true) ? ' checked' : '' ?>>
          <?= h(t($label)) ?> <span class="muted"><?= (int)$result['counts'][$code] ?></span></label>
      <?php endforeach; ?>
    </fieldset>
    <div class="row">
      <label><?= h(t('From')) ?><input type="date" name="from" value="<?= h($f['from']) ?>"></label>
      <label><?= h(t('Until')) ?><input type="date" name="to" value="<?= h($f['to']) ?>"></label>
    <label class="check"><input type="checkbox" name="voided" value="1"<?= $f['voided'] ? ' checked' : '' ?>>
      <?= h(t('Show deleted and corrected entries ({n})', ['n' => (int)$result['voided_count']])) ?></label>
    <label><?= h(t('CSV for')) ?><select name="style"><?= options(['excel' => t('Excel (semicolon, decimal comma)'), 'standard' => t('Other tools (comma, decimal point)')], $style) ?></select></label>
    <button class="btn small"><?= h(t('Show')) ?></button>
    <?php if ($filtered): ?><a class="btn small" href="<?= h(url('timeline', $base)) ?>"><?= h(t('Clear filter')) ?></a><?php endif; ?>
    </div>
  </form>
</details>
<div class="actions">
  <a class="btn" href="<?= h(url('timeline', $query + ['style' => $style, 'format' => 'csv'])) ?>"><?= h(t('Export CSV')) ?></a>
</div>

<?php if (!$result['rows']): ?>
  <p class="muted"><?= h($result['total'] ? t('Nothing matches the filter.') : t('Nothing recorded yet.')) ?></p>
<?php else: ?>
<table class="list timeline">
  <tr><th><?= h(t('Date')) ?></th><th><?= h(t('What')) ?></th><th class="num"><?= h($onBike ? t('Bike km') : t('Part km')) ?></th></tr>
  <?php foreach ($result['rows'] as $r):
      [$mainKm, $mainSt] = $onBike ? [$r['bike_km'], $r['bike_km_status']] : [$r['part_km'], $r['part_km_status']]; ?>
  <tr class="<?= $r['voided'] ? 'voided' : '' ?>">
    <td><?= h($r['date']) ?></td>
    <td><strong><?= h($r['title']) ?></strong>
      <?php if ($onBike && $r['component_id'] && $r['component'] && !str_contains($r['title'], $r['component'])): ?>
        · <a href="<?= h(url('part', ['id' => $r['component_id']])) ?>"><?= h($r['component']) ?></a>
      <?php elseif (!$onBike && $r['bike_id']): ?>
        <span class="muted">· <?= h(t('on {bike}', ['bike' => $r['bike']])) ?></span>
      <?php endif; ?>
      <?php if ($r['detail']): ?><br><span class="muted"><?= h($r['detail']) ?></span><?php endif; ?>
      <?php if ($r['voided']): ?> <span class="muted"><?= h(t('(deleted: {why})', ['why' => (string)$r['void_reason']])) ?></span><?php endif; ?>
    </td>
    <td class="num"><?= $mainSt ? h(Timeline::kmText($mainKm, $mainSt)) : '' ?>
      <?php if ($onBike && $r['component_id'] && $r['part_km_status']): ?><br><span class="muted"><?= h(t('part {km}', ['km' => Timeline::kmText($r['part_km'], $r['part_km_status'])])) ?></span><?php endif; ?>
      <?php if (!$onBike && $r['bike_km_status']): ?><br><span class="muted"><?= h(t('bike {km}', ['km' => Timeline::kmText($r['bike_km'], $r['bike_km_status'])])) ?></span><?php endif; ?>
      <?php if ($r['same_day_km']): ?><br><span class="muted"><?= h(t('+ up to {km} that day', ['km' => km($r['same_day_km'])])) ?></span><?php endif; ?>
      <?php if ($r['cost_cents'] !== null): ?><br><span class="muted"><?= h(money($r['cost_cents'])) ?> €</span><?php endif; ?>
    </td>
  </tr>
  <?php endforeach; ?>
</table>
<p class="muted"><?= h(t('{shown} of {total} entries. The CSV has the same entries, oldest first, with record ids.', ['shown' => count($result['rows']), 'total' => $result['total']])) ?></p>
<?php endif; ?>
