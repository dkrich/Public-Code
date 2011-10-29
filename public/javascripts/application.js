// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//jQuery.ajaxSetup({
//  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
//})

//jQuery.fn.submitWithAjax = function() {
//  this.submit(function() {
//    $.post(this.action, $(this).serialize(), null, "script");
//    return false;
//  })
//  return this;
//};

//$(document).ready(function() {
//  $("#user_session_new").submitWithAjax();
//})

jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

jQuery(document).ready(function() {
    $('.login_image').bind('click', function() {
      $('#header_error_messages_container').remove()
    });
});

jQuery(document).ready(function() {
    $('.sign_up_button').bind('click', function() {
      $('#header_error_messages_container').remove()
    });
});

jQuery(function($) {
  // create a convenient toggleLoading function
  var toggleLoading = function() {$("#loading").toggle()};
  var toggleButton = function() {$(".submit_button").toggle()};

  $("#tool-form")
    .ajaxStart(toggleButton)
    .ajaxStart(toggleLoading)
    .ajaxComplete(toggleButton)
    .ajaxComplete(toggleLoading)
});

//jQuery(function($) {
  // create a convenient toggleLoading function
  //var toggleButton = function() {$(".place_order_button").hide()};
  //var toggleLoading = function() {$("#place_order_loading").show()};

  //$(".place_order_button").click(toggleButton);
  //$(".place_order_button").click(toggleLoading);
  
//});

jQuery(function($) {
  // create a convenient toggleLoading function
  //var toggleLoading = function() {$("#loading").toggle()};
  //var toggleButton = function() {$(".send_order_button").toggle()};
  //var toggleQuantity = function() {$(".remove_button").fadeOut(500)};

  //$(".send_order_button").bind('click', function() {
  //    $("#loading").show();
  //    $(".send_order_button").hide();
  //})
      //.ajaxStart(toggleButton)
      //.ajaxStart(toggleLoading)
  //$(".send_order_button").ajaxStart(toggleQuantity);
      //.ajaxComplete(toggleButton)
      //.ajaxComplete(toggleLoading)
  //$(".send_order_button").ajaxComplete(toggleQuantity);
});

$(function() {

  // Make sure that this button click was responsible for triggering AJAX event.
  $("#settings").click(function() {
         //$('.settings_illuminated').hide();
         $('.settings').fadeOut(500);
         $('.finished').delay(600).fadeIn(500);
         $('#finished').delay(600).fadeIn(500);
   });
   $("#finished").click(function() {
         //$(".finished_illuminated").hide();
         $(".finished").fadeOut(500);
         $(".settings").delay(600).fadeIn(500);
         $("#settings").delay(600).fadeIn(500);
   });
   
});

$(function() {
    $( "#accordion" ).accordion({
        autoHeight: false,
        collapsible: true,
        active: false
    });
});

$(function() {
   var showLoading = function() {$("#purchase_loading").show()};
   var hideButton = function() {$(".actions").hide()};

   $(".actions").click(showLoading);
   $(".actions").click(hideButton);
})
