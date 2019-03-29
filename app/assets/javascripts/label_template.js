class LabelField {
  constructor({ id, field, prefix = null, image = false, textIfFieldSet = false } = {}) {
    this.id = id;
    this.field = field;
    this.prefix = prefix;
    this.image = image;
    this.textIfFieldSet = textIfFieldSet;
  }

  text(text) {
    if (this.prefix !== null) {
      return `${this.prefix}: ${text}`;
    } else {
      return text;
    }
  }

  fieldSelector() {
    return `input[name=${this.field}]`;
  }
}

class LabelTemplate {
  constructor({ preview, form, templates } = {}) {
    this.preview = $(preview);
    this.svg = this.preview.find("svg")[0];
    this.form = $(form);
    this.templates = $(templates);
    if (this.form.length) {
      this.form.on("change", this.updateFields.bind(this));
    }
    if (this.templates.length) {
      this.templates.on("change", this.getTemplate.bind(this));
    }
  }

  getTemplate(event) {
    let template = this.templates.val();
    $.ajax({
      url: `/label_templates/${template}`,
      data: this.getTemplateData(),
      success: this.updateTemplate.bind(this),
      dataType: "text"
    });
  }

  getTemplateData() {
    let data = {};
    this.labelMapping().forEach(function(label) {
      data[label.field] = this.fieldText(label);
    }.bind(this));
    return data;
  }

  updateTemplate(data) {
    this.preview.html(data);
    this.svg = this.preview.find("svg")[0];
  }

  updateFields(event) {
    if (this.svg === null) {
      console.error('SVG element not found on page');
      return false;
    }
    this.labelMapping().forEach(this.updateLabel.bind(this));
    return false;
  }

  updateLabel(label) {
    if (label.textIfFieldSet) {
      this.textIfFieldSet(label);
    } else if (label.image) {
      this.updateImage(label);
    } else {
      this.updateTextLabel(label);
    }
  }

  updateImage(label) {
    let image = this.fieldText(label);
    let el = this.svgEl(label.id);
    if (image != "" && el) {
      el.setAttribute("xlink:href", image);
    }
  }

  updateTextLabel(label) {
    let text = this.fieldText(label);
    this.updateText(label.id, label.text(text));
  }

  updateText(id, text) {
    let el = this.svgEl(id);
    if (el) {
      el.textContent = text;
    }
  }

  textIfFieldSet(label) {
    let text = this.fieldText(label);
    if (text === undefined || text === "") {
      this.updateText(label.id, label.text(""));
    } else {
      this.updateText(label.id, label.textIfFieldSet);
    }
  }

  fieldText(label) {
    return this.form.find(label.fieldSelector()).val();
  }

  svgEl(selector) {
    return this.svg.getElementById(selector);
  }

  labelMapping() {
    return [
      new LabelField({
        id: 'beername',
        field: 'name'
      }),
      new LabelField({
        id: 'description1',
        field: 'description1'
      }),
      new LabelField({
        id: 'description2',
        field: 'description2'
      }),
      new LabelField({
        id: 'description3',
        field: 'description3'
      }),
      new LabelField({
        id: 'description4',
        field: 'description4'
      }),
      new LabelField({
        id: 'beerdetails1',
        field: 'abv',
        prefix: 'ABV'
      }),
      new LabelField({
        id: 'beerdetails2',
        field: 'ibu',
        prefix: 'IBU'
      }),
      new LabelField({
        id: 'beerdetails3',
        field: 'ebc',
        prefix: 'EBC'
      }),
      new LabelField({
        id: 'beerdetails4',
        field: 'og',
        prefix: 'OG'
      }),
      new LabelField({
        id: 'beerdetails5',
        field: 'fg',
        prefix: 'FG'
      }),
      new LabelField({
        id: 'beerdetails6',
        field: 'brewdate',
        textIfFieldSet: "Bryggdatum:"
      }),
      new LabelField({
        id: 'beerdetails7',
        field: 'brewdate'
      }),
      new LabelField({
        id: 'beerdetails8',
        field: 'contactinfo'
      }),
      new LabelField({
        id: 'bottlesize',
        field: 'bottlesize'
      }),
      new LabelField({
        id: 'logo',
        field: 'logo_url',
        image: true
      }),
      new LabelField({
        id: 'mainimage',
        field: 'mainimage_url',
        image: true
      }),
      new LabelField({
        id: 'mainimagewide',
        field: 'mainimage_wide_url',
        image: true
      }),
      new LabelField({
        id: 'mainimagefull',
        field: 'mainimage_full_url',
        image: true
      }),
      new LabelField({
        id: 'qrcode',
        field: 'qrcode',
        image: true
      })
    ];
  }
}
