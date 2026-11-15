<div class="actions">
  <a class="btn primary" href="<?= h(url('part_edit')) ?>"><?= h(t('+ Add part')) ?></a>
  <a class="btn" href="<?= h(url('groupset')) ?>"><?= h(t('+ Groupset')) ?></a>
  <a class="btn" href="<?= h(url('part_life')) ?>"><?= h(t('Part life')) ?></a>
  <a class="btn" href="<?= h(url('products')) ?>"><?= h(t('Products')) ?></a>
  <form method="get" class="row inline-form">
    <input type="hidden" name="r" value="parts">
    <select name="type"><?= options(Catalog::typesByCategory(), $type, true, t('All types')) ?></select>
    <select name="show"><?= options(['active' => t('In use and spares'), 'all' => t('Including retired')], $filter) ?></select>
    <button class="btn small"><?= h(t('Filter')) ?></button>
  </form>
</div>
<?php if (!$parts): ?><p class="muted"><?= h(t('No parts yet. Add one with just a type and a name.')) ?></p><?php endif; ?>
<table class="list">
  <thead><tr><th><?= h(t('Part')) ?></th><th><?= h(t('Type')) ?></th><th><?= h(t('Where')) ?></th><th class="num"><?= h(t('Km')) ?></th></tr></thead>
  <?php foreach (group_identical($parts, fn($x) => [$x['component_type'], Domain::componentName($x), $x['status'], $x['bike']['id'] ?? null, Domain::totalsLabel($x['totals'])]) as $g): $p = $g[0]; ?>
  <tr class="<?= $p['status'] === 'RETIRED' ? 'retired' : '' ?>">
    <td><?= group_name_html($g) ?></td>
    <td><?= h(Catalog::typeName($p['component_type'])) ?></td>
    <td><?= $p['status'] === 'RETIRED' ? status_badge('RETIRED') : ($p['bike'] ? h($p['bike']['name']) : '<span class="muted">' . h(t('spare')) . '</span>') ?></td>
    <td class="num"><?= h(Domain::totalsLabel($p['totals'])) ?></td>
  </tr>
  <?php endforeach; ?>
</table>
