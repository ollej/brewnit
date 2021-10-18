class SvgToPng
  def initialize(svg, width:, height:)
    @svg = svg
    @width = width
    @height = height
  end

  def convert
    raise SvgToPngError.new("Inkscape not found!") unless self.class.inkscape_present?
    png_temp_file = Tempfile.new(['label_png', '.png'], binmode: true)
    Tempfile.create(['label_svg', '.svg'], binmode: true) do |svg_temp_file|
      svg_temp_file.write @svg
      command = svg_to_png_command(png_temp_file.path, svg_temp_file.path)
      Rails.logger.debug { "Converting SVG to PNG with command: #{command}" }
      system command
    end
    return png_temp_file
  end

  def svg_to_png_command(png_path, svg_path)
    if self.class.inkscape_version == '1'
      return "#{self.class.inkscape_path} -o #{png_path} -w #{@width} -h #{@height} #{svg_path}"
    else
      return "#{self.class.inkscape_path} -z -y 0 -e #{png_path} -w #{@width} -h #{@height} #{svg_path}"
    end
  end

  def self.inkscape_version
    @inkscape_version ||= ENV.fetch('INKSCAPE_VERSION', '0')
  end

  def self.inkscape_path
    @inkscape_path ||= ENV.fetch('INKSCAPE_PATH', '')
  end

  def self.inkscape_present?
    inkscape_path.present? && File.exist?(inkscape_path)
  end

  class SvgToPngError < StandardError; end
end
