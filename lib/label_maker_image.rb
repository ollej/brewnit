class LabelMakerImage < LabelMaker
  def initialize(template)
    Rails.logger.debug { "Generate label pdf using rsvg2" }
    @png_temp = template.generate_png
    @image = @png_temp.path
  end

  private
  def render_label(hposition, vposition)
    pdf.image @image, {
      width: LabelTemplate::WIDTH,
      height: LabelTemplate::HEIGHT,
      position: hposition,
      vposition: vposition
    }
  end

  def cleanup
    @png_temp.unlink
  end
end
