class LabelField {
  constructor({ id, field, prefix = null, image = false, textIfFieldSet = false, skipUpdate = false } = {}) {
    this.id = id;
    this.field = field;
    this.prefix = prefix;
    this.image = image;
    this.textIfFieldSet = textIfFieldSet;
    this.skipUpdate = skipUpdate;
  }

  text(text) {
    if (this.prefix !== null) {
      return `${this.prefix}: ${text}`;
    } else {
      return text;
    }
  }

  fieldSelector() {
    return `[name=${this.field}]`;
  }
}

class LabelTemplate {
  constructor({ preview, form, templates, updateSelectors } = {}) {
    this.preview = $(preview);
    this.svg = this.preview.find("svg")[0];
    this.form = $(form);
    this.templates = $(templates);
    if (this.form.length) {
      this.form.on("change", this.updateFields.bind(this));
    }
    $(updateSelectors).on("change", this.getTemplate.bind(this));
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
    this.form.trigger("LabelTemplate:update", {
      "labelTemplate": this,
      "templateData": data,
      "templateElement": this.svg
    });
  }

  updateFields(event) {
    if (this.svg === null) {
      console.error('SVG element not found on page');
      return false;
    }
    this.labelMapping().forEach(this.updateLabel.bind(this));
  }

  updateLabel(label) {
    if (label.skipUpdate) {
      return;
    }
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
    if (label.id === 'style') {
      console.log(label);
      console.log(label.text(text));
    }
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
        id: 'abv',
        field: 'abv'
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
        id: 'brewdate',
        field: 'brewdate'
      }),
      new LabelField({
        id: 'contactinfo',
        field: 'contactinfo'
      }),
      new LabelField({
        id: 'bottlesize',
        field: 'bottlesize'
      }),
      new LabelField({
        id: 'brewery',
        field: 'brewery'
      }),
      new LabelField({
        id: 'beerstyle',
        field: 'beerstyle'
      }),
      new LabelField({
        id: 'malt-header',
        field: 'malt1',
        textIfFieldSet: "Malt:"
      }),
      new LabelField({
        id: 'malt1',
        field: 'malt1'
      }),
      new LabelField({
        id: 'malt2',
        field: 'malt2'
      }),
      new LabelField({
        id: 'hops-header',
        field: 'hops1',
        textIfFieldSet: "Humle:"
      }),
      new LabelField({
        id: 'hops1',
        field: 'hops1'
      }),
      new LabelField({
        id: 'hops2',
        field: 'hops2'
      }),
      new LabelField({
        id: 'yeast-header',
        field: 'yeast',
        textIfFieldSet: "Jäst:"
      }),
      new LabelField({
        id: 'yeast',
        field: 'yeast'
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
      }),
      new LabelField({
        id: 'border',
        field: 'border',
        image: true,
        skipUpdate: true
      }),
      new LabelField({
        id: 'background',
        field: 'background',
        image: true,
        skipUpdate: true
      })
    ];
  }
}
