class LabelField {
  constructor({ id, field, prefix = null } = {}) {
    this.id = id;
    this.field = field;
    this.prefix = prefix;
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

class LabelMaker {
  constructor(svg, form) {
    this.svg = document.getElementById(svg);
    this.form = $(form);
    this.form.on("change", this.update.bind(this));
    this.update();
  }

  update(event) {
    this.labelMapping().forEach(this.updateLabel.bind(this));
    return false;
  }

  updateLabel(label) {
    let text = this.fieldText(label);
    this.svg.getElementById(label.id).textContent = label.text(text);
  }

  fieldText(label) {
    return this.form.find(label.fieldSelector()).val();
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
      })
    ];
  }

}
