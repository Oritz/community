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


$(document).ready(function () {
  // Join and quit groups
  var quitGroup = function () {
    var form_token = $('meta[name="csrf-token"]').attr('content');
    if (form_token) {
      $.ajax({
        url: this.href,
        type: 'POST',
        dataType: 'json',
        context: this,
        data: {_method: 'delete', authenticity_token: form_token},
        error: function () {Messenger().post('退出小组失败');},
        success: function(data, textStatus) {
          if (textStatus === 'success') {
            Messenger().post('成功退出小组');
            $(this).html('加入小组');
            $(this).attr('href', '/groups/' + data.data.group_id + '/add_user.json');
            $(this).parent().attr('class', 'groups_b_cz_jr');
            $(this).parent().unbind('click').on('click', 'a', joinGroup);
          }
          else {
            show_message(data);
          }
        }
      });
    }
    return false;
  };

  var joinGroup = function () {
    var form_token = $('meta[name="csrf-token"]').attr('content');
    if (form_token) {
      $.ajax({
        url: this.href,
        type: 'POST',
        dataType: 'json',
        context: this,
        data: {_method: 'put', authenticity_token: form_token},
        error: function () {Messenger().post('加入小组失败');},
        success: function(data, textStatus) {
          if (textStatus === 'success') {
            Messenger().post('成功加入小组');
            $(this).html('退出');
            $(this).attr('href', '/groups/' + data.data.group_id + '/remove_user.json');
            $(this).parent().attr('class', 'groups_b_cz_tc');
            $(this).parent().unbind('click').on('click', 'a', quitGroup);
          }
          else {
            show_message(data);
          }
        }
      });
    }
    return false;
  };

  $('span.groups_b_cz_tc').on('click', 'a', quitGroup);
  $('span.groups_b_cz_jr').on('click', 'a', joinGroup); 

  // send message box
  function clearPM() {
    $('#pm_recipient_name').val('');
    $('#pm_recipient_content').val('');
  }

  $('.letter-send').click(function () {
    $.fancybox.open($('#private_message_box'), {
      closeBtn: false,
      closeClick: false,
      width: 600,
      modal: true,
      afterClose: function () {clearPM();},
    });
  });

  $('.pm_popup_closebtn').click(function () {
    $.fancybox.close();
  });

  $('#bn_pm_send').click(function () {
    var form_token = $('meta[name="csrf-token"]').attr('content');
    var recipient_name = $.trim($('#pm_recipient_name').val());
    var recopient_content = $.trim($('#pm_recipient_content').val());

    $.ajax({
      url: '/private_messages.json',
      type: 'POST',
      dataType: 'json',
      data: {
        authenticity_token: form_token,
        recipient_name: recipient_name,
        'private_message[content]': recopient_content,
      },
      error: function () {
        $.fancybox.close();
      },
      success: function(data, textStatus) {
        $.fancybox.close();
        location.reload();
      }
    });
  });

  $('#bn_pm_cancel').click(function () {
    $.fancybox.close();
  });
});
