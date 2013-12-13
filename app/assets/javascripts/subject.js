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
			autoHeight: true,
			afterClose: function() {clearFile();},
		});
	});
	
	// Auto upload selected image
	$('#subject_qiniu_upload').on('change', '#upload_img_file', function(){
		if ($('#upload_img_file').val()) {
		  $('#subject_qiniu_upload').ajaxSubmit({
		    success: function(response) {
		      alert('success');
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
    alert('save!');
    $.fancybox.close();
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
