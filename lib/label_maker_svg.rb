class LabelMakerSvg < LabelMaker
  def initialize(label_template)
    @svg = label_template.generate_svg
  end

  private

  def render_label(vposition, hposition)
    pdf.svg @svg, {
      enable_web_requests: false,
      position: hposition,
      vposition: vposition
    }
  end
end
