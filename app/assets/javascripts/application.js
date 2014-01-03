// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require messenger
//= require messenger-theme-future
//= require_tree ../../../vendor/assets/javascripts
//= require flash_message
//= require misc
//= require tipoff

function change_nav_height($block) {
  nav_height = $(window).height() - 40;
  $block.css("height", nav_height);
}

function toggle_nav($block, position) {
  var properties;
  var px_str = "+=0px";
  var is_hide = parseInt($block.attr("is_hide"));
  if(is_hide == 0)
    px_str = "-=255px";
  if(position == "left") {
    properties = {left: px_str};
  }
  else if(position == "right") {
    properties = {right: px_str};
  }
  else
    return;
  $block.animate(properties, 100, function() {
    $block.attr("is_hide", (is_hide+1)%2);
  });
}

$.fn.nav_float = function() {
  var position = function(element) {
    var top = element.position().top;
    var pos = element.css("position");
    $(window).scroll(function() {
      var scrolls = $(this).scrollTop();
      if (scrolls > top) {
        if (window.XMLHttpRequest) {
          element.css({
            position: "fixed",
            top: 0
          }).addClass("shadow");
        }
        else {
          element.css({
            top: scrolls
          });
        }
      }else {
        element.css({
          position: pos,
          top: top
        }).removeClass("shadow");
      }
    });
  };
  return $(this).each(function() {
    position($(this));
  });
};


function showGoTop () {
  var h = $(window).height();
  var t = $(document).scrollTop();
  if(t > h) {
    $('#gotop,#code').show();
  } else {
    $('#gotop,#code').hide();
  }
}


$(document).ready(function () {
  // nav top
  showGoTop();

  // Go top!
  $('#gotop').click(function () {
    $(document).scrollTop(0);
  });

  $('#code').hover(
    function (){
      $(this).attr('id','code_hover');
      $('#code_img').show(300);
    },
    function(){
      $(this).attr('id','code');
      $('#code_img').hide();
  });

  $(window).scroll(function () {
    showGoTop();
  });

  // calculate level
  change_nav_height($("#sns_nav .nav-left1"));
  change_nav_height($("#sns_nav .nav-right1"));
  $(window).resize(function() {
    change_nav_height($("#sns_nav .nav-left1"));
    change_nav_height($("#sns_nav .nav-right1"));
  });
  $("#sns_nav .nav-btn1").click(function() {
    toggle_nav($("#sns_nav .nav-left1"), "left");
  });
  $("#sns_nav .nav-btn2").click(function() {
    toggle_nav($("#sns_nav .nav-right1"), "right");
  });

  $("#sns_nav").nav_float();

  // popup tipoff
});
