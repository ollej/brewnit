class SvgToPng
  def initialize(svg, width:, height:)
    @svg = svg
    @width = width
    @height = height
  end

  def convert
    png_temp_file = Tempfile.new(['label_png', '.png'], binmode: true)
    Tempfile.create(['label_svg', '.svg'], binmode: true) do |svg_temp_file|
      svg_temp_file.write @svg
      svg_command = "inkscape -z -y 0 -e #{png_temp_file.path} -w #{@width} -h #{@height} #{svg_temp_file.path}"
      Rails.logger.debug { "Converting SVG to PNG with command: #{svg_command}" }
      system svg_command
    end
    return png_temp_file
  end
end
