class LabelTemplates
  DEFAULT = 'back-label'

  def initialize(path:)
    @path = path
  end

  def templates
    @templates ||= Hash[Dir.glob(@path.join("*.svg")).sort.map do |filename|
      [File.basename(filename, '.svg'), filename]
    end]
  end

  def list
    templates.keys
  end

  def template(name = DEFAULT)
    templates.fetch(name) { templates[DEFAULT] }
  end
end
