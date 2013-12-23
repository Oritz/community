
var bind_textarea_limit = function(textarea_input, textarea_hint, textarea_submit, limit_num) {
  if (!textarea_input || limit_num <= 0) {
    return;
  }
  
  var default_text = '<span class="countTxt">还能输入</span><strong class="maxNum">' + limit_num + '</strong><span>个字</span>';
  var textarea_input_trigger = function () {
    var char_length = get_unicode_length(textarea_input.val());
    var disable_sumit = true;
    var hint_text = default_text;
    if (char_length === 0) {
      disable_sumit = true;
    }
    else if (char_length > limit_num) {
      disable_sumit = true;
      hint_text = '<span class="countTxt">已经超过</span><strong class="overNum">' + (char_length - limit_num) + '</strong><span>个字</span>';
    }
    else {
      disable_sumit = false;
      hint_text = '<span class="countTxt">还能输入</span><strong class="maxNum">' + (limit_num - char_length) + '</strong><span>个字</span>';
    }

    if (typeof textarea_hint == 'object') {
      textarea_hint.html(hint_text);
    }
    
    if (disable_sumit) {
      textarea_submit.attr('disable', '');
      textarea_submit.parents('form').submit(function() {
        return false;
      });
    }
    else {
      textarea_submit.removeAttr('disable');
      textarea_submit.parents('form').submit(function() {
        return true;
      });
    }
  };

  textarea_input.keyup(textarea_input_trigger);
  if (textarea_hint) {
    textarea_submit.click(function () {
      textarea_hint.html(default_text);
    });
  }
};
