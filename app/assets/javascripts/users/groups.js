$(document).ready(function() {
  $('span.groups_b_cz_tc').on('click', 'a', function() {
    var form_token = $('meta[name="csrf-token"]').attr('content');
    if (form_token) {
      $.ajax(functio());  
    }
    return false;
  });
  
  $('span.groups_b_cz_jr').on('click', 'a', function() {
    alert('join');
    
    return false;
  }); 
});