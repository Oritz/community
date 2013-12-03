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
