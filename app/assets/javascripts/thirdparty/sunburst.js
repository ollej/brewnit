class Sunburst {
  constructor(sel, tab, data) {
    this.width = 280;
    this.height = 280;
    this.drawn = false;
    this.redraw = this.redraw.bind(this);
    this.sel = sel;
    this.tab = tab;
    this.data = data;
    this.radius = Math.min(this.width, this.height) / 2;
    this.color = d3.scale.ordinal().range(["#637939", "#8ca252", "#b5cf6b", "#cedb9c"]); //category20b()
    this.tip = d3.tip().attr('class', 'd3-tip').html(d => d != null ? d.tooltip : undefined);
    $("body").on("tab-changed", this.redraw);
    if ($(this.sel).is(":visible")) {
      this.redraw(null, this.tab);
    }
  }

  setup() {
    this.svg = d3.select(this.sel).append("svg")
      .attr("width", this.width)
      .attr("height", this.height)
      .append("g")
      .attr("transform", "translate(" + (this.width / 2) + "," + (this.height / 2) + ")");

    this.svg.call(this.tip);

    this.partition = d3.layout.partition()
      .sort(null)
      .size([2 * Math.PI, this.radius * this.radius])
      .value(d => d.size);

    this.arc = d3.svg.arc()
      .startAngle(d => d.x)
      .endAngle(d => d.x + d.dx)
      .innerRadius(d => Math.sqrt(d.y))
      .outerRadius(d => Math.sqrt(d.y + d.dy));
  }

  redraw(ev, id) {
    if (id !== this.tab) { return; }
    if (this.drawn) { return; }
    this.init();
    this.drawn = true;
  }

  init() {
    this.setup();
    const path = this.svg.datum(this.data).selectAll("path")
      .data(this.partition.nodes)
      .enter().append("g");

    path.append("path")
      .attr("display", function(d) { if (d.depth) { return null; } else { return "none"; } }) // hide inner ring
      .attr("d", this.arc)
      .style("stroke", "#fff")
      .style("fill", d => {
        const color_node = d.children ? d : d.parent;
        return this.color(color_node.name);
      })
      .style("fill-rule", "evenodd")
      .attr("id", (d, i) => `hopsArc_${i}`)
      .attr("class", function(d) { if (d.size != null) { return "hopsArc"; } })
      .each(function(d) { return d.arcWidth = (this.getTotalLength() / 2) - 20; });

    path.append("svg:text")
      .attr("display", function(d) { if (d.depth) { return null; } else { return "none"; } }) // hide inner ring
      .attr("x", 5)   // Move the text from the start angle of the arc
      .attr("dy", 18) // Move the text down
      .append("textPath")
      .attr("xlink:href", (d, i) => `#hopsArc_${i}`)
      .attr("class", function(d) { if (d.size != null) { return "hopsArc"; } })
      .text(d => d.name)
      .each(this.truncate);

    this.svg.selectAll(".hopsArc")
      .on('mouseover', this.tip.show)
      .on('mouseout', this.tip.hide);
  }

  truncate(d,i) {
    const self = d3.select(this);
    let textLength = self.node().getComputedTextLength();
    let text = self.text();
    return (() => {
      const result = [];
      for (let char of Array.from(text)) {
        if ((textLength > d.arcWidth) && text.length) {
          text = text.slice(0, -1);
          self.text(text + '…');
          result.push(textLength = self.node().getComputedTextLength());
        } else {
          result.push(undefined);
        }
      }
      return result;
    })();
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).Sunburst = Sunburst;
