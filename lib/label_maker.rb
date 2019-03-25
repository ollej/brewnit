require  "prawn/measurement_extensions"

class LabelMaker
  def initialize(template)
    @template = template
  end

  def generate
    build.render
  end

  private
  def build
    render_labels
    render_footer(90.mm)
    render_footer(188.mm)
    pdf
  end

  def render_labels
    %i(top center bottom).each do |vposition|
      %i(left center right).each do |hposition|
        pdf.svg @template, {
          enable_web_requests: false,
          position: hposition,
          vposition: vposition
        }
      end
    end
    self
  end

  def render_footer(hposition)
    path = Rails.root.join('app', 'assets', 'images', 'brygglogg-logo-hires.png')
    pdf.image path, width: 1.cm, at: [25.mm, hposition]
    pdf.image path, width: 1.cm, at: [145.mm, hposition]
    pdf.font "Merriweather" do
      pdf.text_box "Etiketter utskrivna från Brygglogg.se",
        at: [42.mm, hposition - 2.mm]
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
end
