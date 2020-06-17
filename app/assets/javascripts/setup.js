$( document ).ready(function() {
  // Expand menu on small screens
  $(".nav-menu-button").on("click", function() {
    $("#nav").toggleClass("active");
    return false;
  })

  // Handle clicks in recipe list
  $(".linked-list").on("click", ".linked-item", function(ev) {
    let $target = $(ev.target);
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
  let dataGauge = new DataGauge(".gauge-chart");
  dataGauge.init();

  // Click on comments count opens comments tab.
  $(".pure-badge-comments").on("click", function() {
    $("#tab3").click();
  });

  // Update like button
  $(".recipe-content").on("ajax:success", "a.like-link", function(e, data, status, xhr) {
    $(this).replaceWith(xhr.responseText);
  });

  // Close modals
  $("body").on("click", function() {
    if (!$("#brew-timer").is(":visible")) {
      $(".modal").hide();
    }
  });

  // Setup range sliders
  let sliders = new RangeSliders(".range-slider");
  sliders.init();

  // Image upload
  let uploader = new MediaUpload(".upload-button", "#uploadMediaField", "#slider");
  uploader.init();

  // Media Tools
  let mediaTools = new MediaTools("li.media-thumbnail", ".media-buttons", "#slider");
  mediaTools.init();

  // Initialize flasher
  let flasher = new Flasher("#flasher");

  // Auto submit quicksearch
  $("#sort_order").on('change', function() {
    this.form.submit();
  });

  $("form.medal-placement #event_medal").on("change", function() {
    let $cat = $("form.medal-placement #event_category");
    $cat.prop('disabled', ($(this).val() == ''));
  });

  $("body").on("click", "a[disabled]", function(ev) {
    ev.preventDefault();
  });

  $("form.js-auto-submit").change(function(event) {
    $(this).trigger("submit.rails");
  });

  $("form[data-remote=true]").on('ajax:error', function(event, xhr, status, error) {
    const json = xhr.responseJSON;
    if (json && json['error']) {
      console.error('Received AJAX error', json['error']);
      $('body').trigger('flasher:show', {
        message: 'json ' + json['error'],
        level: 'error'
      })
    }
  });

  $(".file-button").on("click", function(ev) {
    const $field = $(this.dataset.fileField);
    const $form = $field.closest("form");
    $field.one("change", function(ev) {
      $form.find("#recipe_name").attr('required', false);
      $form.submit();
    });
    $field.trigger("click");
  });

  // Setup LabelMaker to update preview
  let labelTemplate = new LabelTemplate({
    preview: "#preview-template",
    form: ".label-form",
    templates: "select#template",
    updateSelectors: "select#template, select#background, select#border"
  });

  // Setup Dropdown to cancel on escape or click on body
  let dropdown = new Dropdown(".purecss-dropdown", ".dd-input", ".dd-menu");

  // Repopulate style select when a style guide is selected
  let styleGuide = new StyleGuide("#style_guide", "#style");

  // Color picker for label template
  // TODO: Read palette from selected background, border, main image, logo
  // TODO: Allow full color picker
  // TODO: Byt font
  var labelColor = new LabelColor({
    picker: ".picker",
    textsel: "#preview-template text tspan",
    input: "input[name=textcolor]",
    form: ".label-form"
  });

  // Activate comments tab
  const anchor = window.location.hash;
  if (anchor && anchor.startsWith("#commontator-comment-")) {
    $("#tab3").prop("checked", true);
  }

  const recipeId = $("#recipe_article").data("recipeId");
  if (recipeId) {
    $(".brew-timer").each(function(index) {
      new BrewTimerDialog($(this), recipeId);
    });
  }
});

