class StyleGuide {
  constructor(styleguide, style) {
    this.styleguide = $(styleguide);
    this.style = $(style);
    if (this.styleguide.length) {
      this.styleguide.on('change', this.fetchStyles.bind(this));
    }
  }

  fetchStyles(event) {
    let styleGuide = this.styleguide.val();
    let url = `/style_guides/${styleGuide}.json`;
    $.get(url, this.updateStyles.bind(this));
  }

  updateStyles(data) {
    this.style.find("option").remove();
    $.each(data, function(index, style) {
      this.style
         .append($("<option></option>")
          .attr("value", style["id"])
          .text(style["name"]));
    }.bind(this));
  }
}
