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

YUI().use('node-base', 'node-event-delegate', 'node-event-simulate', function (Y) {
  var menuButton = Y.one('.nav-menu-button'),
      nav        = Y.one('#nav');

  // Setting the active class name expands the menu vertically on small screens.
  menuButton.on('click', function (e) {
    nav.toggleClass('active');
  });


  // Handle clicks in recipe list
  var handleClick = function handleClick(ev) {
    Y.all('#list .recipe-item').removeClass('recipe-item-selected');
    this.addClass('recipe-item-selected');
    location.href = this.one('a').get('href');
    return false;
  }
  Y.delegate("click", handleClick, '#list', ".recipe-item");

});
