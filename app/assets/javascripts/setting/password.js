//= require parsley
$(document).ready(function() {
  $("form").parsley({
    errors: {
      container: function(elem) {
        return $(elem).parent().find(".account-error");
      }
    },
    listeners: {
      onFieldError: function(elem) {
        $(elem).parent().find(".account-error").html("");
      },
      onFieldSuccess: function(elem) {
        $(elem).parent().find(".account-error").html("");
      }
    }
  });
});
