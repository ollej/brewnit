class Sunburst
  width: 280
  height: 280
  drawn: false

  constructor: (@sel, @tab, @data) ->
    @radius = Math.min(@width, @height) / 2
    @color = d3.scale.ordinal().range(["#637939", "#8ca252", "#b5cf6b", "#cedb9c"]) #category20b()
    @tip = d3.tip().attr('class', 'd3-tip').html((d) -> d?.tooltip)
    $("body").on("tab-changed", @redraw)
    if $(@sel).is(":visible")
      console.log "asdf"
      @redraw(null, @tab)

  setup: ->
    @svg = d3.select(@sel).append("svg")
      .attr("width", @width)
      .attr("height", @height)
      .append("g")
      .attr("transform", "translate(" + @width / 2 + "," + @height / 2 + ")")

    @svg.call(@tip)

    @partition = d3.layout.partition()
      .sort(null)
      .size([2 * Math.PI, @radius * @radius])
      .value((d) -> d.size)

    @arc = d3.svg.arc()
      .startAngle((d) -> d.x)
      .endAngle((d) -> d.x + d.dx)
      .innerRadius((d) -> Math.sqrt(d.y))
      .outerRadius((d) -> Math.sqrt(d.y + d.dy))

  redraw: (ev, id) =>
    return unless id == @tab
    return if @drawn
    @init()
    @drawn = true

  init: ->
    @setup()
    path = @svg.datum(@data).selectAll("path")
      .data(@partition.nodes)
      .enter().append("g")

    path.append("path")
      .attr("display", (d) -> if d.depth then null else "none") # hide inner ring
      .attr("d", @arc)
      .style("stroke", "#fff")
      .style("fill", (d) =>
        color_node = if d.children then d else d.parent
        @color(color_node.name)
      )
      .style("fill-rule", "evenodd")
      .attr("id", (d,i) -> "hopsArc_#{i}")
      .attr("class", (d) -> "hopsArc" if d.size?)
      .each((d) -> d.arcWidth = this.getTotalLength() / 2 - 20)

    path.append("svg:text")
      .attr("display", (d) -> if d.depth then null else "none") # hide inner ring
      .attr("x", 5)   # Move the text from the start angle of the arc
      .attr("dy", 18) # Move the text down
      .append("textPath")
      .attr("xlink:href", (d,i) -> "#hopsArc_#{i}")
      .attr("class", (d) -> "hopsArc" if d.size?)
      .text((d) -> d.name)
      .each(@truncate)

    @svg.selectAll(".hopsArc")
      .on('mouseover', @tip.show)
      .on('mouseout', @tip.hide)

  truncate: (d,i) ->
    self = d3.select(this)
    textLength = self.node().getComputedTextLength()
    text = self.text()
    for char in text
      if textLength > d.arcWidth && text.length
        text = text.slice(0, -1)
        self.text(text + '…')
        textLength = self.node().getComputedTextLength()

(exports ? this).Sunburst = Sunburst
