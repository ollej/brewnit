class LabelMakerImage < LabelMaker
  def initialize(template)
    @image = template.generate_png
  end

  private

  def render_label(vposition, hposition)
    pdf.image @image, {
      position: hposition,
      vposition: vposition
    }
  end
end
