$(document).ready(function () {
  //----------------------------------------------------------------
  // Variables
  //----------------------------------------------------------------
  var enable_quit_hint = true;
  var subject_title = $('#subject_title');
  var subject_content = $('#subject_content');
  var subject_id = $('#subject_id').val();
  var cloud_storage_id = 0;
  var form_token = $('meta[name="csrf-token"]').attr('content');
  var auto_save_time = 60000;
  var auto_save_timeout_id = 0;
 
 
  //----------------------------------------------------------------
  // Helpers
  //----------------------------------------------------------------
  // clear file field 
  function clearFile() {
    var file = $('#upload_img_file');
    if (file.val()) {
      file.after(file.clone().val(''));
      file.remove();
    }
    
    $('.upload_img_show').children().remove();
    cloud_storage_id = 0;
  }
  
  // clear link field
  function clearLink() {
    $('#link_text_desc').val('');
    $('#link_text_url').val('');
  }
  
  // insert text into texterea
  function insertAtCaret(textObj, textFeildValue) {  
    if(document.all && textObj.createTextRange && textObj.caretPos){       
        var caretPos = textObj.caretPos;      
        caretPos.text = caretPos.text.charAt(caretPos.text.length - 1) == '' ? textFeildValue + '' : textFeildValue; 
    } else if(textObj.setSelectionRange){
        var rangeStart = textObj.selectionStart;
        var rangeEnd = textObj.selectionEnd;     
        var tempStr1 = textObj.value.substring(0, rangeStart);      
        var tempStr2 = textObj.value.substring(rangeEnd);      
        textObj.value = tempStr1 + textFeildValue + tempStr2;
        textObj.focus();
        var len = textFeildValue.length;
        textObj.setSelectionRange(rangeStart + len,rangeStart + len);
        textObj.blur();
    } else {
      textObj.value += textFeildValue;
    }
  }
  
  // Save subject
  function saveSubject() {
    if (subject_title.val() || subject_content.val() ) {
      $.ajax({
        url: '/subjects/' + subject_id + '.json',
        type: 'POST',
        dataType: 'json',
        data: {
          _method: 'put',
          authenticity_token: form_token,
          'subject[title]': subject_title.val(),
          'subject[content]': subject_content.val(),
          utf8: '✓',
          is_post: 0,
        },
        error: function () {
          Messenger().post('保存文章失败');
        },
        success: function(data, textStatus) {
          if (textStatus == 'success') {
            Messenger().post('成功保存文章');
          }
          else {
            show_message(data);
          }
        },
      });
    }
    auto_save_timeout_id = setTimeout(saveSubject, auto_save_time);
  }
  
  
  //----------------------------------------------------------------
  // Binding events
  //----------------------------------------------------------------
  // Auto save
  auto_save_timeout_id = setTimeout(saveSubject, auto_save_time);
  
  // Hint of quit page
  window.onbeforeunload = function (event) {
    if (enable_quit_hint && ($.trim(subject_title.val()) || $.trim(subject_content.val()))) {
      return "长文章未提交，确定退出吗？";
    }
  };
  
  // Bind insert image
  $('#insert_img').click(function () {
    $.fancybox.open($('#insert_img_box'), {
      closeBtn: false,
      closeClick: false,
      modal: true,
      afterClose: function () {clearFile();},
    });
  });
  
  // Auto upload selected image
  $('#subject_qiniu_upload').on('change', '#upload_img_file', function () {
    if ($('#upload_img_file').val()) {
      $('#subject_qiniu_upload').ajaxSubmit({
        success: function(response) {
          // Show thumb
          $('.upload_img_show').html('<img alt="' + response.img_name +  '" src="' + response.dest_url + '?imageView/2/w/118/h/118">');
          cloud_storage_id = response.storage_id;
        },
        error: function(response) {
          Messenger().post("上传图片出错");
          clearFile();
        },
      });
    }
  });
  
  // Save the image box
  $('#upload_img_save').click(function () {
    // Save the setting
    if ($('#upload_img_file').val() && cloud_storage_id != 0) {
        $.ajax({
          url: '/subjects/' + subject_id + '/post_images.json',
          type: 'POST',
          dataType: 'json',
          data: {
            authenticity_token: form_token,
            subject_id: subject_id,
            cloud_storage_id: cloud_storage_id,
          },
          error: function () {
            Messenger().post('保存图片失败');
            $.fancybox.close();
          },
          success: function(data, textStatus) {
            if (textStatus === 'success') {
              var img_text_content = '<图片' + data.data.id + '>';
              // Add show block
              var hidden_img_block = $('#hidden_img_block');
              hidden_img_block.after(hidden_img_block.clone());
              hidden_img_block.attr('id', 'images_block_' + data.data.id);
              hidden_img_block.find('.bit_img.fl h3').html('图片' + data.data.id);
              hidden_img_block.find('.bit_img_tx img').attr('src', data.data.url + '?imageView/2/w/118/h/118');
              hidden_img_block.find('.bit_bewrite textarea').val('');
              
              // Add to the edit
              insertAtCaret(subject_content.get(0), img_text_content);
              Messenger().post('成功保存图片');
            }
            else {
              show_message(data);
            } 
            
            $.fancybox.close();       
          },
      });
    }
    else {
      $.fancybox.close();
    }

    //alert('save!');
    //$.fancybox.close();
  });
               
  // Cancel the image box
  $('#upload_img_cancel').click(function () {
    $.fancybox.close();
  });
  
  // Bind insert link
  $('#insert_link').click(function () {
    $.fancybox.open($('#insert_link_box'), {
      closeBtn: false,
      closeClick: false,
      modal: true,
      afterClose: function () {clearLink();},
    });
  });
  
  // Save the link
  $('#link_save').click(function () {
    // Insert into text body
    var link_desc = $('#link_text_desc').val();
    var link_url = $('#link_text_url').val();
    // check the url
    if (link_url) {
      if (link_url.substr(0, 7) !== 'http://') {
        link_url = 'http://' + link_url;
      }
     
      if (!link_desc) {
        link_desc = link_url;
      }
      
      insertAtCaret(subject_content.get(0), '<a href="' + link_url + '">' + link_desc + '</a>');
    }
    // Close popup box
    $.fancybox.close();
  });
  
  // Cancel the link
  $('#link_cancel').click(function () {
    $.fancybox.close();
  });
  
  // Bind close fancybox
  $('.subject_popup_closebtn').click(function () {
    $.fancybox.close();
  });
  
  // Remove the posted image
  $('span.article_close a').click(function () {
    var image_block = $(this).parents('li');
    if (image_block) {
      var image_block_id = $(image_block).attr('id');
      var deleted_image_id = image_block_id.match(/images_block_(\d+)/);
      if (deleted_image_id) {
        deleted_image_id = deleted_image_id[1];
        $.ajax({
          url: '/subjects/' + subject_id + '/post_images/' + deleted_image_id + '.json',
          type: 'POST',
          dataType: 'json',
          data: {
            _method: 'delete',
            authenticity_token: form_token,
            subject_id: subject_id,
            id: deleted_image_id,
          },
          error: function () {
            Messenger().post('删除图片失败');
          },
          success: function(data, textStatus) {
            if (textStatus == 'success') {
              console.log(data);
              Messenger().post('成功删除图片');
              $(image_block).remove();
            }
            else {
              show_message(data);
            }
          },
        });
      }
    }
  });
  
  // bind ajax save
  $('.edit_subject').submit(function () {
    var clicked_val = $("button[type=submit][clicked=true]").val();
    // save button
    if (clicked_val == 0) {
      // reset auto save timer
      if (auto_save_timeout_id !== 0) {
        clearTimeout(auto_save_timeout_id);
      }
      saveSubject();
      return false;
    }
    // sumit the form 
    else if (clicked_val == 1) {
      enable_quit_hint = false;
    }
  });

  $('.edit_subject button[type=submit]').click(function () {
    $('.edit_subject button[type=submit]').removeAttr("clicked");
    $(this).attr("clicked", "true");
  });
});
