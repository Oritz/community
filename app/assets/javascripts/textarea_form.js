//------------------------------------------------------------------------------------------------------------------------
// Submit and refresh the post form
// options:
//  form_selector:  selector of form
//  limit_num:      limited length of charater in textarea
//  reset:          true or false
//  success:        callback of success
//  error:          callback of failed
//------------------------------------------------------------------------------------------------------------------------
function textarea_form(options) {
  var $post_form = $(options.form_selector);
  if ($post_form === undefined) {
    return;
  }

  var $text_area = $post_form.find('textarea');
  var $charlimit_hint = $post_form.find('.countTxt_block');
  var $submit_button = $post_form.find('input[type="submit"]');
  var default_text = '<span class="countTxt">还能输入</span><strong class="maxNum">' + options.limit_num + '</strong><span>个字</span>';

  // refresh the post form
  var textarea_refresh = function () {
    var char_length = $text_area.val().length;
    var disable_sumit = true;
    var hint_text = default_text;
    if (char_length > options.limit_num) {
      hint_text = '<span class="countTxt">已经超过</span><strong class="overNum">' + (char_length - options.limit_num) + '</strong><span>个字</span>';
    }
    else if (char_length <= options.limit_num && char_length > 0) {
      disable_sumit = false;
      hint_text = '<span class="countTxt">还能输入</span><strong class="maxNum">' + (options.limit_num - char_length) + '</strong><span>个字</span>';
    }

    // Display the hint
    if (typeof $charlimit_hint == 'object') {
      $charlimit_hint.html(hint_text);
    }

    // Change the submit button state
    if (disable_sumit) {
      $submit_button.attr('disable', '');
    }
    else {
      $submit_button.removeAttr('disable');
    }
  };

  // submit the form
  var form_submit = function () {
    var textarea_value = $.trim($text_area.val());
    if (textarea_value.length == 0 || textarea_value.length > options.limit_num) {
      return;
    }

    var post_values = {};
    post_values[$text_area.attr('name')] = textarea_value;
    // Get hidden values
    $post_form.find('input[type="hidden"]').each(function () {
      post_values[$(this).attr('name')] = $(this).val();
    });
    $.ajax({
      url: $post_form.attr('action') + '.json',
      type: $post_form.attr('method'),
      dataType: 'json',
      data: post_values,
      error: function (data) {
        if(options.reset) {
          $post_form.find(":input").not("[name=utf8]").not("[name=authenticity_token]").not(":submit").attr("value", "");
        }
        if (options.error) {
          options.error(data);
        }
      },
      success: function(data) {
        // clear value
        $text_area.val('');
        if(options.reset) {
          $post_form.find(":input").not("[name=utf8]").not("[name=authenticity_token]").not(":submit").attr("value", "");
        }
        $charlimit_hint.html(default_text);
        if (options.success) {
          options.success(data);
        }
      }
    });
  };

  // Bind events
  $post_form.submit(function () {return false;});
  $post_form.on('keyup', 'textarea', textarea_refresh);
  $post_form.on('click', 'input[type="submit"]', form_submit);
}
