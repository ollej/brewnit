class SvgAvatar
  THEME_TWO_LINES = :two_lines
  THEME_TWO_LETTERS = :two_letters

  THEME_DEFAULTS = {
    two_lines: {
      fontsize: 16,
      backgroundcolor: "#fab32a"
    },
    two_letters: {
      fontsize: 32,
      backgroundcolor: "#df9c25"
    }
  }

  def initialize(theme, values = {})
    @theme = theme
    @values = values
  end

  def default_values
    #opts[:height] ||= opts[:width]
    #opts[:fontsize] ||= opts[:height] / 2
    {
      avatar_class: "item-avatar",
      text_class: "avatar-text",
      textcolor: "#ffffff",
      backgroundcolor: "#df9c25",
      texts: [
        "SVG"
      ],
      width: 64,
      height: 64
    }.with_indifferent_access
  end

  def avatar_values
    default_values.merge(THEME_DEFAULTS[@theme]).merge(@values)
  end

  def partial
    {
      partial: "shared/svg_avatar/#{@theme}",
      locals: avatar_values
    }
  end
end
