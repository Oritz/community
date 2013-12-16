function show_level($blocks) {
  var total_level = 20;
  var $levels = $blocks.find(".total-level .level");
  var $total_levels = $blocks.find(".total-level");
  if($levels.length <= 0 || $total_levels.length <= 0)
    return;
  var i = 0;
  for(i = 0; i < $levels.length; ++i) {
    var $level = $($levels[i]);
    var $total_level = $($total_levels[i]);
    var level_count = $level.attr("level");
    if(typeof level_count == "undefined")
      return;
    level_count = parseInt(level_count);
    var level_width = $total_level.width() * level_count / total_level;
    $level.width(level_width);
  }
}
