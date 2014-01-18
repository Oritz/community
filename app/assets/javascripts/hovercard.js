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
      var card_displayed = false;
      
      if (data_type !== 'undefined' && data_defs[data_type] !== 'undefined' && data_id !== NaN) {
        var card_obj = $('#' + data_defs[data_type]['card_id'] + data_id);
        var ajax_request;
        
        var fade_in = function () {
          if (card_displayed) {
            return;
          }
          
          var display_hovercard = function () {
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
            var arrow_style = "";
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
                arrow_style += 'border-bottom-color: #fef7e4;';
                if ((right_interval + obj_width) >= card_width) {
                  card_style += 'left: ' + obj_offset.left + 'px; top: ' + (obj_offset.top + obj_height) + 'px;';
                  arrow_style += 'top: -8px; left: 29px;';
                }
                else {
                  card_style += 'left: ' + (obj_offset.left + obj_width - card_width) + 'px; top: ' + (obj_offset.top + obj_height) + 'px;';
                  arrow_style += 'top: -8px; left: ' + (card_width - 43) + 'px;';
                }
                break;
              case 'arrow-down':
                arrow_style += 'border-top-color: #fef7e4;';
                if ((right_interval + obj_width) >= card_width) {
                  card_style += 'left: ' + obj_offset.left + 'px; top: ' + (obj_offset.top - card_height) + 'px;';
                  arrow_style += 'top: ' + (card_height - 8) + 'px; left: 29px;';
                }
                else {
                  card_style += 'left: ' + (obj_offset.left + obj_width - card_width) + 'px; top: ' + (obj_offset.top - card_height) + 'px;';
                  arrow_style += 'top: ' + (card_height - 8) + 'px; left: ' + (card_width - 43) + 'px;';
                }
                break;
              case 'arrow-left':
                arrow_style += 'border-right-color: #fef7e4;';
                if ((bottom_interval + obj_height) >= card_height) {
                  card_style += 'left: ' + (obj_offset.left + obj_width) + 'px; top: ' + obj_offset.top + 'px;';
                  arrow_style += 'top: 29px; left: -8px;';
                }
                else {
                  card_style += 'left: ' + (obj_offset.left + obj_width) + 'px; top: ' + (obj_offset.top + obj_height - card_height) + 'px;';
                  arrow_style += 'top: ' + (card_height - 43) + 'px; left: -8px;';
                }
                break;
              case 'arrow-right':
                arrow_style += 'border-left-color: #fef7e4;';
                if ((bottom_interval + obj_height) >= card_height) {
                  card_style += 'left: ' + (obj_offset.left - card_width) + 'px; top: ' + obj_offset.top + 'px;';
                  arrow_style += 'top: 29px; left: ' + (card_width - 9) + 'px;';
                }
                else {
                  card_style += 'left: ' + (obj_offset.left - card_width) + 'px; top: ' + (obj_offset.top + obj_height - card_height) + 'px;';
                  arrow_style += 'top: ' + (card_height - 43) + 'px; left: ' + (card_width - 9) + 'px;';
                }
                break;
              case 'arrow-none':
                break;
            }
            
            if (arrow_to != 'arrow-none') {
              // Display it
              card_obj.attr('style', card_style);
              card_obj.find('.arrow').attr('style', arrow_style);
              card_obj.fadeIn();
              card_displayed = true;
            }
          };
          
          if (card_obj.length == 0) {
            // fetch the data
            ajax_request = $.ajax({
              url: data_defs[data_type]['url'] + data_id + '.json',
              type: "GET",
              success: function (data, status) {
                card_obj = $('.' + data_defs[data_type]['card_tpl']).clone();
                card_obj.addClass('card-loading');
                card_obj.removeClass(data_defs[data_type]['card_tpl']);
                card_obj.attr('id', data_defs[data_type]['card_id'] + data_id);
                card_obj.find('.group-name').html('<a target="_blank" href="/groups/' + data['id'] + '">' + data['name'] + '</a>');
                card_obj.find('.group-members').html(data['member_count']);
                card_obj.find('.group-posts').html(data['recommend_count'] + data['subject_count'] + data['talk_count']);
                $('.SK-hovercards').append(card_obj);
                
                display_hovercard();
              },
              //error: function () {},
            });
          } 
          else {
            display_hovercard();
          } 
        };
        
        var fade_out = function () {
            if (card_obj.length && card_displayed) {
            card_obj.fadeOut();
            card_displayed = false;
          }
        };
        
        // binding event
        var fadeout_timeout;
        var fadein_timeout;   
        var timed_fade_in = function () {
          if (fadeout_timeout !== 'undefined') {
            clearTimeout(fadeout_timeout);
            fadeout_timeout = 'undefined';
          }
          fadein_timeout = setTimeout(fade_in, 1000);         
        };
        
        var timed_fade_out = function () {
          if (fadein_timeout !== 'undefined') {
            clearTimeout(fadein_timeout);
            fadein_timeout = 'undefined';
          }
          
          fadeout_timeout = setTimeout(fade_out, 1000);
        };
        
        $(this).on('mouseenter', '', timed_fade_in);
        $(document).on('mouseenter', '#' + data_defs[data_type]['card_id'] + data_id, timed_fade_in);
        $(this).on('mouseleave', '', timed_fade_out);
        $(document).on('mouseleave', '#' + data_defs[data_type]['card_id'] + data_id, timed_fade_out);
      }          
    });
  };
})(jQuery);


// Binding hover events
$('.hover-card').hovercard();
