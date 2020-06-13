class Style {
  constructor(data) {
    this.data = data;
  }

  id() {
    return this.data["id"];
  }

  number() {
    return this.data["number"];
  }

  letter() {
    return this.data["letter"];
  }

  name() {
    return this.data["name"];
  }

  styleCode() {
    return `${this.number()}${this.letter()}`;
  }

  optionText() {
    return `${this.styleCode()}. ${this.name()}`;
  }
}

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
    $.each(data, function(index, style_data) {
      let style = new Style(style_data);
      this.style
         .append($("<option></option>")
           .attr("value", style.id())
           .text(style.optionText()));
    }.bind(this));
  }
}
