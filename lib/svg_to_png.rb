class SvgToPng
  def initialize(svg, width:, height:)
    @svg = svg
    @width = width
    @height = height
  end

  def convert
    #convert_with_rmagick
    convert_with_rsvg
  end

  def convert_with_rmagick
    img = Magick::Image.from_blob(@svg) do
      self.format = 'SVG'
      self.background_color = 'transparent'
    end
    temp_file = Tempfile.new(['label_png', '.png'], binmode: true)
    img[0].write "png:" + temp_file.path
    return temp_file
  end

  def convert_with_rsvg
    png_data = convert_svg_to_png(@svg, @width, @height)
    return generate_png_file(png_data)
  end

  def generate_png_file(png_data)
    temp_file = Tempfile.new(['label_png', '.png'], binmode: true)
    temp_file.write(png_data.read)
    return temp_file
  end

  def convert_svg_to_png(svg_xml, width, height)
    rsvg = RSVG::Handle.new_from_data(svg_xml)
    surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, width, height)
    Cairo::Context.new(surface).render_rsvg_handle(rsvg)
    buffer = StringIO.new
    surface.write_to_png(buffer)
    buffer.rewind
    return buffer
  end
end
