function show_level($block) {
  var total_level = 20;
  var $level = $block.find(".total-level .level");
  var $total_level = $block.find(".total-level");
  if($level.length <= 0 || $total_level.length <= 0)
    return;
  var level_count = $level.attr("level");
  if(typeof level_count == "undefined")
    return;
  level_count = parseInt(level_count);
  var level_width = $total_level.width() * level_count / total_level;
  $level.width(level_width);
}
