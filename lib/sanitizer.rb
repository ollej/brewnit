class Sanitizer
  def initialize(options = {})
    @options = options.reverse_merge!(
      tags: [],
      attributes: []
    )
  end

  def sanitize(value)
    html_entity_decode sanitizer.sanitize(value, @options.slice(:tags, :attributes))
  end

  private
  def sanitizer
    @sanitizer ||= Rails::Html::WhiteListSanitizer.new
  end

  def html_entity_decode(value)
    if @options[:html_entity_decode] == true
      HTMLEntities.new.decode(value)
    else
      value
    end
  end
end
