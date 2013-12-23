$(document).ready(function() {
  $("#subNav").children().click(function() {
    $(this).parent().children().removeClass("active");
    $(this).addClass("active");
  });
});
