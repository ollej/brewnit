class LabelMaker {
  constructor(svg, form) {
    this.svg = document.getElementById(svg);
    this.form = $(form);
    this.form.on("change", this.update.bind(this));
    this.update();
  }

  update(event) {
    this.labelMapping().forEach(this.updateText.bind(this));
    return false;
  }

  updateText(label) {
    let input_selector = `input[name=${label.field}]`;
    let input = this.form.find(input_selector)
    let text = input.val();
    if (label.prefix !== undefined) {
      text = label.prefix + text;
    }
    this.svg.getElementById(label.id).textContent = text;
  }

  labelMapping() {
    return [
      {
        field: 'name',
        id: 'beername'
      },
      {
        field: 'description1',
        id: 'description1'
      },
      {
        field: 'description2',
        id: 'description2'
      },
      {
        field: 'description3',
        id: 'description3'
      },
      {
        field: 'description4',
        id: 'description4'
      },
      {
        field: 'abv',
        id: 'beerdetails1',
        prefix: 'ABV: '
      },
      {
        field: 'ibu',
        id: 'beerdetails2',
        prefix: 'IBU: '
      },
      {
        field: 'ebc',
        id: 'beerdetails3',
        prefix: 'EBC: '
      },
      {
        field: 'og',
        id: 'beerdetails4',
        prefix: 'OG: '
      },
      {
        field: 'fg',
        id: 'beerdetails5',
        prefix: 'FG: '
      },
      {
        field: 'brewdate',
        id: 'beerdetails7'
      },
      {
        field: 'contactinfo',
        id: 'beerdetails8'
      },
      {
        field: 'bottlesize',
        id: 'bottlesize'
      }
    ];
  }

}
