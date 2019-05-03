class LabelColor {
  constructor({ picker, textsel, input, form } = {}) {
    this.picker = $(picker);
    this.textsel = textsel;
    this.input = $(input);
    this.form = $(form);
    this.defaults = {
      'allowRecent': true,
      'recentMax': 5,
      'initialColor': '#000000',
      'palette': ["#1abc9c", "#16a085", "#2ecc71", "#27ae60", "#3498db", "#2980b9", "#9b59b6", "#8e44ad", "#34495e", "#2c3e50", "#f1c40f", "#f39c12", "#e67e22", "#d35400", "#e74c3c", "#c0392b", "#ecf0f1", "#bdc3c7", "#95a5a6", "#7f8c8d"],
      'paletteLabel': 'Färger',
      'recentLabel': 'Tidigare',
      'allowCustomColor': true,
      'onColorChange': this.onColorChange.bind(this),
      'onColorSelected': function() {
        this.options.onColorChange(this.color, this);
      }
    };
    this.form.on("LabelTemplate:update", this.onTemplateUpdate.bind(this));
    this.setupPicker(this.defaults.palette);
  }

  onColorChange(color, picker) {
    this.picker.css({'backgroundColor': color, 'color': color});
    this.color = color;
    $(this.textsel).css("fill", color);
    this.input.val(color);
  }

  onTemplateUpdate(event) {
    $(this.textsel).css({
      "fill": this.color,
      "stroke": "#000000",
      "stroke-width": "0.1px",
      "paint-order": "stroke"
    });
  }

  setupPicker(palette) {
    let options = $.extend({}, this.defaults, { 'palette': palette });
    this.picker.colorPick(options);
  }
}
