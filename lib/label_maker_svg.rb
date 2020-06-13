class LabelMakerSvg < LabelMaker
  def initialize(label_template)
    Rails.logger.debug { "Generate label pdf using prawn-svg2" }
    @svg = label_template.generate_svg
  end

  private

  def render_label(hposition, vposition)
    pdf.svg @svg, {
      enable_web_requests: false,
      position: hposition,
      vposition: vposition
    }
  end
end
