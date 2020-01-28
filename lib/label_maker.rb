require  "prawn/measurement_extensions"

class LabelMaker
  def generate
    build.render
  end

  def self.create(template)
    if LabelMakerImage.supported?
      LabelMakerImage.new(template).generate
    else
      LabelMakerSvg.new(template).generate
    end
  end

  private
  def build
    begin
      render_labels
      render_footer(90.mm)
      render_footer(188.mm)
    ensure
      cleanup
    end
    pdf
  end

  def render_labels
    %i(top center bottom).each do |vposition|
      %i(left center right).each do |hposition|
        render_label hposition, vposition
      end
    end
    self
  end

  def render_footer(hposition)
    path = Rails.root.join('app', 'assets', 'images', 'brygglogg-logo-hires.png')
    pdf.image path, width: 1.5.cm, at: [25.mm, hposition + 2.5.mm]
    pdf.image path, width: 1.5.cm, at: [145.mm, hposition + 2.5.mm]
    pdf.font "Merriweather" do
      pdf.text_box "Etiketter utskrivna från Brygglogg.se",
        at: [52.mm, hposition - 2.mm]
    end
    self
  end

  def pdf
    return @pdf if @pdf.present?
    @pdf ||= Prawn::Document.new(
      page_size: "A4",
      #margin: 42,
      page_layout: :portrait
    )
    @pdf.font_families.update("Merriweather" => { normal: Rails.root.join('app', 'assets', 'fonts', 'merriweather.ttf') })
    @pdf
  end

  def cleanup
  end
end
