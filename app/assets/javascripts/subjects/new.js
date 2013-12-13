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
	$('#subject_qiniu_upload').on('change', '#upload_img_file', function(){
		if ($('#upload_img_file').val()) {
		  $('#subject_qiniu_upload').ajaxSubmit({
		    success: function(response) {
		      console.log(response);
		      // Show thumb
		      $('.upload_img_show').html('<img alt="' + response.img_name +  '" src="' + response.dest_url + '?imageView/2/w/118/h/118">');
		      $('.upload_img_show').append('<input type="hidden" name="upload_storage_id" value="' + response.storage_id + '">');
		    },
		    error: function(response) {
		      alert(response.status);
		      clearFile();
		    },
		  });
		}
	});
	
	// Save the image box
  $('#upload_img_save').click(function() {
    // Save the setting

    //alert('save!');
    //$.fancybox.close();
  });
          	   
	// Cancel the image box
	$('#upload_img_cancel').click(function() {
    $.fancybox.close();
  });
	
	// Bind insert link
	$('#insert_link').click(function() {
		$.fancybox.open($('#insert_link_box'));
	});
	
	// Bind close fancybox
	$('.subject_popup_closebtn').click(function() {
		$.fancybox.close();
	});
});
