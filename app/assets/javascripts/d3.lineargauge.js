(function() {
  function LinearGauge(sel, options) {
    this.sel = sel;
    var self = this;

    this.init = function(options) {
      this.options = options;
      this.options.marginX = options.marginX || 5;
      this.options.marginY = options.marginY || 5;
      this.options.tickWidth = options.tickWidth || 5;
      this.options.wideTickWidth = options.wideTickWidth || 10;
      this.options.scaleTicks = options.scaleTicks || 7;
      this.options.width = options.width || 25;
      this.options.height = options.height || 100;
      this.options.labelWidth = options.labelWidth || 35;
      this.options.labelFormat = options.labelFormat || ".3f";
      this.options.scaleX = this.options.width + this.options.marginX - this.options.tickWidth;
      this.options.scaleY = this.options.marginY + 1;
      this.options.svgWidth = this.options.width + this.options.marginX * 2 + this.options.labelWidth;
      this.options.svgHeight = this.options.height + this.options.marginY * 2;
      //console.log(this.options);
    };

    this.data = function data(data) {
      // TODO: Calculate min as x% less than minimum given value
      this.scaleMin = d3.min(data.ranges, function(obj) { return obj.from; });
      this.scaleMax = d3.max(data.ranges, function(obj) { return obj.to; });
      this.scale = d3.scale.linear()
        .domain([this.scaleMin, this.scaleMax])
        .range([this.options.height, 0]);

      if (data.ranges) {
        this.ranges = data.ranges;
      }
      if (data.value) {
        this.value(data.value);
      }
      this.render();
    };

    this.value = function value(value) {
      // TODO: Get values from options
      this.marker = {
        value: value,
        color: "blue",
        stroke: "2px",
        width: this.options.width + this.options.tickWidth * 2
      };
    };

    this.render = function render() {
      // TODO: Remove old svg
      this.svg = d3.select(this.sel).append("svg")
        .attr("width", this.options.svgWidth)
        .attr("height", this.options.svgHeight);
      this.drawBox();
      this.drawRanges(this.ranges);
      this.drawScale();
      this.drawMarker(this.marker);
    };

    this.drawBox = function drawBox() {
      // TODO: Draw fluff to look like refractometer
      var outerRect = this.svg.append("rect")
        .attr("x", this.options.marginX).attr("y", this.options.marginY)
        .attr("height", this.options.height + 2).attr("width", this.options.width)
        .style("fill", "none")
        .style("stroke", "black")
        .style("stroke-width", "2px");
    };

    this.drawRanges = function drawRanges(ranges) {
      ranges.forEach(function(range) {
        this.drawRect(range);
      }, this);
    };

    this.drawRect = function drawRect(rect) {
      // TODO: Add id, remove current if existing
      // TODO: Get color from color range
      var fromX = this.scale(rect.from);
      var toX = this.scale(rect.to);
      var height = fromX - toX;
      //console.log(rect, fromX, toX, height, rect.from, rect.to, this.options.marginX, this.options.marginY);

      this.svg.append("rect")
        .attr("x", this.options.marginX + 1)
        .attr("y", this.options.marginY + 1 + toX)
        .attr("width", this.options.width - 2)
        .attr("height", height)
        .style("fill", function() {
          return "url(#" + rect.color + "_COLOR)";
        });
        //.style("fill", rect.color);
    };

    this.drawMarker = function drawMarker(marker) {
      // TODO: Add id, remove current if existing
      var xPos = this.scale(marker.value);
      this.svg.append("line")
        .attr("x1", 0)
        .attr("y1", this.options.marginY + xPos)
        .attr("x2", marker.width)
        .attr("y2", this.options.marginY + xPos)
        .style("stroke", marker.color)
        .style("stroke-width", marker.stroke);
    };

    this.drawScale = function drawScale() {
      // TODO: Draw minor ticks shorter
      this.axis = d3.svg.axis()
        .scale(this.scale)
        .orient("right")
        .ticks(this.options.scaleTicks)
        .tickSize(this.options.tickWidth)
        .tickFormat(d3.format(this.options.labelFormat));
      this.svg.append("g")
        .attr("class", "axis")
        .attr("transform", "translate(" + this.options.scaleX + "," + this.options.scaleY + ")")
        .call(this.axis);
    };

    this.init(options);
  }

  (typeof exports !== "undefined" && exports !== null ? exports : this).LinearGauge = LinearGauge;
}).call(this);

