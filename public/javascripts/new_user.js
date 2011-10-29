jQuery(function($) {
  // create a convenient toggleLoading function
  var toggleLoading = function() {$("#loading").toggle()};
  var toggleButton = function() {$(".register_button").toggle()};

  $(".register_button")
    .ajaxStart(toggleButton)
    .ajaxStart(toggleLoading)
    .ajaxComplete(toggleButton)
    .ajaxComplete(toggleLoading)
});
