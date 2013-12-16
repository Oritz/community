$(document).ready(function() {

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
    $('#cloud_storage_id').val('');
  }
  
  // clear link field
  function clearLink() {
    $('#link_text_desc').val('');
    $('#link_text_url').val('');
  }
  
  // insert text into texterea
  function insertAtCaret(textObj, textFeildValue){  
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
  
  //----------------------------------------------------------------
  // Binding events
  //----------------------------------------------------------------
	// Bind insert image
	$('#insert_img').click(function() {
		$.fancybox.open($('#insert_img_box'), {
			closeBtn: false,
			closeClick: false,
			modal: true,
			afterClose: function() {clearFile();},
		});
	});
	
	// Auto upload selected image
	$('#subject_qiniu_upload').on('change', '#upload_img_file', function() {
		if ($('#upload_img_file').val()) {
		  $('#subject_qiniu_upload').ajaxSubmit({
		    success: function(response) {
		      console.log(response);
		      // Show thumb
		      $('.upload_img_show').html('<img alt="' + response.img_name +  '" src="' + response.dest_url + '?imageView/2/w/118/h/118">');
		      // Set the storage id
		      $('#cloud_storage_id').val(response.storage_id);
		    },
		    error: function(response) {
		      Messenger().post("上传图片出错");
		      clearFile();
		    },
		  });
		}
	});
	
	// Save the image box
  $('#upload_img_save').click(function() {
    // Save the setting
    if ($('#upload_img_file').val() && $('#cloud_storage_id').val()) {
      $('#post_subject_image').ajaxSubmit({
        success: function(response) {
          var img_text_content = '<图片' + response.data.storage_id + '>';
          
          // Add show block
          var hidden_img_block = $('#hidden_img_block');
          hidden_img_block.after(hidden_img_block.clone());
          hidden_img_block.attr('id', 'images_block_' + response.data.storage_id);
          hidden_img_block.find('.bit_img fl h3').html('图片' + response.data.storage_id);
          hidden_img_block.find('.bit_img_tx img').attr('src', response.data.url + '?imageView/2/w/118/h/118');
          hidden_img_block.find('.bit_bewrite textarea').val('');
          
          // Add to the edit
          insertAtCaret($('#subject_body').get(0), img_text_content);

          // Close fancybox
          $.fancybox.close();
        },
        error: function(response) {
          Messenger().post("保存图片出错");
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
	$('#upload_img_cancel').click(function() {
    $.fancybox.close();
  });
	
	// Bind insert link
	$('#insert_link').click(function() {
		$.fancybox.open($('#insert_link_box'), {
      closeBtn: false,
      closeClick: false,
      modal: true,
      afterClose: function() {clearLink();},
    });
	});
	
	// Save the link
  $('#link_save').click(function() {
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
	    
	    insertAtCaret($('#subject_body').get(0), '<a href="' + link_url + '">' + link_desc + '</a>');
	  }
	  // Close popup box
	  $.fancybox.close();
	});
	
	// Cancel the link
	$('#link_save').click(function() {
    $.fancybox.close();
  });
  
	// Bind close fancybox
	$('.subject_popup_closebtn').click(function() {
		$.fancybox.close();
	});
	
	// Remove the posted image
	$('span.article_close a').click(function() {
	  alert("close");
	});
});
