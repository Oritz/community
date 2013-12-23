
function ajax_upload() {
  var options = {
    target: '#response_message',
    error: function(response) {
      // console.log('failure');
      error_data = response.responseJSON;
      switch (response.status) {
        case 400:
          $('#response_message').html("Request parameters error: " + error_data['error']);
          break;
        case 401:
          $('#response_message').html("Request token error: " + error_data['error']);
          break;
        case 579:
          $('#response_message').html("Sonkwo server error: " + error_data['error']);
          break;
        case 599:
          $('#response_message').html("Qiniu server error: " + error_data['error']);
          break;
        //case 608:
          //break;
        case 612:
          $('#response_message').html("File error: " + error_data['error']);
          break;
        case 614:
          $('#response_message').html("File existed: " + error_data['error']);
          break;
        case 630:
          $('#response_message').html("Can't create bucket: " + error_data['error']);
          break;
        case 631:
          $('#response_message').html("Can't find bucket: " + error_data['error']);
          break;
        case 701:
          $('#response_message').html("Data checksum error: " + error_data['error']);
          break;
        default:
          break;   
      }
    },
    success: function(response) {
      // console.log('success');
      $('#response_message').html("Upload success: <img src='" + response['dest_url'] + "'>");
    }
  };

  jQuery('#qiniu_uploader').ajaxSubmit(options);
};
