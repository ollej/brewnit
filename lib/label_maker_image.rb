class LabelMakerImage < LabelMaker
  def initialize(template)
    Rails.logger.debug { "Generate label png using inkscape" }
    @template = template
  end

  def self.supported?
    @@supported ||= SvgToPng.inkscape_present?
  end

  private
  def render_label(hposition, vposition)
    pdf.float do
      pdf.image image, {
        fit: [52.5.mm, 70.mm],
        position: hposition,
        vposition: vposition
      }
    end
  end

  def image
    return @image unless @image.nil?
    @png_temp = @template.generate_png
    @image = @png_temp.path
  end

  def cleanup
    return if @png_temp.nil?
    @png_temp.close
    @png_temp.unlink
  end
end
