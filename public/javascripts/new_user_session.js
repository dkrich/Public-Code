$(function() {
  // create a convenient toggleLoading function
  var hideLoading = function() {$("#session_loading").hide()};
  var showLoading = function() {$("#session_loading").show()};
  var hideButtons = function() {
      $(".login_image_illuminated").hide();
      $(".login_image").hide();
  };
  var showButtons = function() {
      $(".login_image").show();
  };
  var removeErrors = function() {
      $("#header_error_messages_container").remove();
  };
  $(".login_image_illuminated").ajaxStart(hideButtons);
  $(".login_image_illuminated").ajaxStart(showLoading);
  $(".login_image_illuminated").ajaxStart(removeErrors);
  $(".login_image_illuminated").ajaxComplete(hideLoading);
  $(".login_image_illuminated").ajaxComplete(showButtons);
});

$(function() {
  var toggleIlluminated = function() {
      $('.login_image').toggle();
      $('.login_image_illuminated').toggle();
  };
  
  $('.login_image').mouseover(toggleIlluminated);
  $('.login_image_illuminated').mouseout(toggleIlluminated);
});
