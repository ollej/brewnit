class LabelMaker
  def initialize(template)
    @template = template
  end

  def generate
    build.render
  end

  private
  def build
    %i(top center bottom).each do |vposition|
      %i(left center right).each do |hposition|
        pdf.svg @template, {
          enable_web_requests: false,
          position: hposition,
          vposition: vposition
        }
      end
    end
    pdf
  end

  def pdf
    @pdf ||= Prawn::Document.new(
      page_size: "A4",
      margin: 42
    )
  end
end
