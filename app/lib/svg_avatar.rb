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
    values = values.with_indifferent_access
    if values[:width].present? && !values[:height].present?
      values[:height] = values[:width].present?
    end
    @values = default_values.merge(values)
  end

  def self.for_user(username:, email:, options: {})
    SvgAvatar.new(THEME_TWO_LETTERS, options.merge({
      texts: self.letters_for(username),
      backgroundcolor: SvgAvatarColor.new(email).color
    }))
  end

  def self.letters_for(string)
    words = string.split
    (self.initial(words.first) + self.initial(words.second)).upcase
  end

  def self.initial(string = "")
    (string || "")[0] || ""
  end

  def default_values
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
    @values.merge(THEME_DEFAULTS[@theme]).merge(@values)
  end

  def partial
    {
      partial: "shared/svg_avatar/#{@theme}",
      locals: avatar_values
    }
  end
end
