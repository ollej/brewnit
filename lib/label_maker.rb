require  "prawn/measurement_extensions"

class LabelMaker
  def generate
    build.render
  end

  private
  def build
    render_labels
    render_footer(90.mm)
    render_footer(188.mm)
    cleanup
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
      margin: 42
    )
    @pdf.font_families.update("Merriweather" => { normal: Rails.root.join('app', 'assets', 'fonts', 'merriweather.ttf') })
    @pdf
  end

  def cleanup
  end
end
