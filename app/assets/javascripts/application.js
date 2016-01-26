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
//= require jquery-ui
//= require fancybox
//= require commontator/application
//= require thirdparty/d3
//= require thirdparty/jquery.fileupload
//= require thirdparty/jquery.fileupload-process
//= require thirdparty/jquery.fileupload-validate
//= require_tree .

$( document ).ready(function() {
  // Expand menu on small screens
  $(".nav-menu-button").on("click", function() {
    $("#nav").toggleClass("active");
    return false;
  })

  // Handle clicks in recipe list
  $(".linked-list").on("click", ".linked-item", function(ev) {
    var $target = $(ev.target);
    if ($target.is("a") && !$target.is(".item-link")) {
      return true;
    }
    document.location = $("a.item-link", this).attr("href");
    return false;
  });

  // Trigger redraw-d3 event on tab change
  $(".tabs").on("change", '[id^="tab"]', function() {
    $("body").trigger("tab-changed", [$(this).attr("id")]);
    return false;
  });

  // Setup gauges
  var dataGauge = new DataGauge(".gauge-chart");
  dataGauge.init();

  // Click on comments count opens comments tab.
  $(".pure-badge-comments").on("click", function() {
    $("#tab3").click();
  });

  // Update like button
  $(".recipe-content").on("ajax:success", "a.like-link", function(e, data, status, xhr) {
    $(this).replaceWith(xhr.responseText);
  });

  // Show liked by list
  $(".recipe-content").on("click", ".pure-badge-likes", function(e, data, status, xhr) {
    var $likes = $("#likes-list");
    if ($likes.is(':empty')) {
      return false;
    }
    var $el = $(this);
    $likes.css({
      'position': 'absolute',
      'left': $el.offset().left,
      'top': $el.offset().top + $el.height() + 10
    }).toggle();
    return false;
  });

  // Close modals
  $("body").on("click", function() {
    $(".modal").hide();
  });

  // Setup range sliders
  var sliders = new RangeSliders(".range-slider");
  sliders.init();

  // Image upload
  var uploader = new MediaUpload(".upload-button", "#uploadMediaField", "#slider");
  uploader.init();

  // Media Tools
  var mediaTools = new MediaTools("li.media-thumbnail", ".media-buttons", "#slider");
  mediaTools.init();

  // Initialize flasher
  var flasher = new Flasher("#flasher");
});
