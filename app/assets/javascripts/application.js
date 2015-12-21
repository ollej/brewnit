// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$( document ).ready(function() {
  // Expand menu on small screens
  $(".nav-menu-button").on("click", function() {
    $("#nav").toggleClass("active");
    return false;
  })

  // Handle clicks in recipe list
  $("#list").on("click", ".recipe-item", function(ev) {
    $("#list .recipe-item").removeClass("recipe-item-selected");
    $(this).addClass("recipe-item-selected");
    document.location = $("a", this).attr("href");
    return false;
  });

  // Trigger redraw-d3 event on tab change
  $(".tabs").on("change", '[id^="tab"]', function() {
    $("body").trigger("redraw-d3", [$(this).attr("id")]);
    return false;
  });
});
