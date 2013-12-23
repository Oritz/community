$(document).ready(function() {
  /*
  Messenger.options = {
    extraClasses: 'messenger-fixed messenger-on-top',
    theme: 'block'
  };
   */

  if($(".flash-messages .flash-error").length > 0)
    Messenger().post($(".flash-messages .flash-error").html());
  if($(".flash-messages .flash-alert").length > 0)
    Messenger().post($(".flash-messages .flash-alert").html());
  if($(".flash-messages .flash-notice").length > 0)
    Messenger().post($(".flash-messages .flash-notice").html());
  if($(".flash-messages .flash-success").length > 0)
    Messenger().post($(".flash-messages .flash-success").html());
});

function show_message(data) {
  if(data == "unknow") {
    Messenger().post("网络错误");
    return;
  }
  if(data.status == "error")
    Messenger().post(data.message);
  else if(data.status == "fail") {
    if(typeof data.data.message == "undefined")
      $.each(data.data, function(key, value) {
        Messenger().post(key + ":" + value);
      });
    else
      Messenger().post(data.data.message);
  }
  //else if(data.status == "success")
  //  Messenger().post("操作成功");
  else
    return;
}
