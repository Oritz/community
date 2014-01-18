// Hovercard for sonkwo
// Version 0.1 2014.1.16 by shihx@ceasia.com.cn

// jQuery function
(function ($) {
  var data_defs = {
    group: {url: '/groups/', card_id: 'group-hovercard-', card_tpl: 'group-hovercard-tpl'},
    user: {url: '/users/', card_id: 'user-hovercard-', card_tpl: 'user-hovercard-tpl'},
  };
  
  var display_hovercard = function (data_type, data_detail) {
    
  };
  
  $.fn.hovercard = function(options) {
    return this.each(function () {
      var obj = $(this);
      var data_type = obj.attr('data-type');
      var data_id = parseInt(obj.attr('data-id'));
      if (data_type !== 'undefined' && data_id !== NaN) {
        var card_obj = $('#' + data_defs[data_type]['card_id'] + data_id);
        var ajax_request;
        // binding hover event
        obj.hover(function (event) {    // hover in event
          if (card_obj.length == 0) {
            // Init the hover card
            card_obj = $('.' + data_defs[data_type]['card_tpl']).clone();
            card_obj.addClass('card-loading');
            card_obj.removeClass(data_defs[data_type]['card_tpl']);
            card_obj.attr('id', data_defs[data_type]['card_id'] + data_id);
            $('.SK-hovercards').append(card_obj);
            /*
            var data_url = get_data_url(data_type, data_id);
            // fetch the data
            if (data_url) {
              ajax_request = $.ajax({
                url: data_defs[data_type]['url'] + data_id + '.json',
                type: "GET",
                success: function (data, status) {},
                error: function () {},
              });
            }
            // what do you want???
            else {
              
            }
            */
          }
          
          var card_style = "display:none; position: absolute; z-index: 101;";
          // adjust to view port
          var obj_offset = obj.offset();
          var obj_width = obj.width();
          var obj_height = obj.height();
          var card_width = card_obj.width();
          var card_height = card_obj.height();
          var scroll_left = $(window).scrollLeft();
          var scroll_top = $(window).scrollTop();
          
          var left_interval = obj_offset.left - scroll_left;
          var right_interval = window.innerWidth - obj_offset.left - obj.width() + scroll_left;
          var top_interval = obj_offset.top - scroll_top;
          var bottom_interval = window.innerHeight - obj_offset.top - obj.height() + scroll_top;
          
          var arrow_to = 'arrow-none';
          if (bottom_interval < card_height) {
            if (top_interval >= card_height) {
              arrow_to = 'arrow-down';
            }
            else {
              if (right_interval >= card_width) {
                arrow_to = 'arrow-left';
              }
              else if (left_interval >= card_width) {
                arrow_to = 'arrow-right';
              }
            }
          }
          else {
            arrow_to = 'arrow-up';
          }
          
          switch (arrow_to) {
            case 'arrow-up':
              if ((right_interval + obj_width) >= card_width) {
                card_style += 'left: ' + obj_offset.left + 'px; top: ' + (obj_offset.top + obj_height) + 'px;';
              }
              else {
                card_style += 'left: ' + (obj_offset.left + obj_width - card_width) + 'px; top: ' + (obj_offset.top + obj_height) + 'px;';
              }
              break;
            case 'arrow-down':
              if ((right_interval + obj_width) >= card_width) {
                card_style += 'left: ' + obj_offset.left + 'px; top: ' + (obj_offset.top - card_height) + 'px;';
              }
              else {
                card_style += 'left: ' + (obj_offset.left + obj_width - card_width) + 'px; top: ' + (obj_offset.top - card_height) + 'px;';
              }
              break;
            case 'arrow-left':
              if ((bottom_interval + obj_height) >= card_height) {
                card_style += 'left: ' + (obj_offset.left + obj_width) + 'px; top: ' + obj_offset.top + 'px;';
              }
              else {
                card_style += 'left: ' + (obj_offset.left + obj_width) + 'px; top: ' + (obj_offset.top + obj_height - card_height) + 'px;';
              }
              break;
            case 'arrow-right':
              if ((bottom_interval + obj_height) >= card_height) {
                card_style += 'left: ' + (obj_offset.left - card_width) + 'px; top: ' + obj_offset.top + 'px;';
              }
              else {
                card_style += 'left: ' + (obj_offset.left - card_width) + 'px; top: ' + (obj_offset.top + obj_height - card_height) + 'px;';
              }
              break;
            case 'arrow-none':
              break;
          }
          
          if (arrow_to != 'arrow-none') {
            // Display it
            card_obj.attr('style', card_style);
            card_obj.fadeIn();
          }
          
        }, function(event) {    // hover out event
          if (card_obj.length) {
            card_obj.fadeOut();
          }
        });
      }          
    });
  };
})(jQuery);


// Binding hover events
$('.hover-card').hovercard();
