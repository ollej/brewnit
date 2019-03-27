class LabelTemplates
  DEFAULT = 'back-label'

  def initialize(path: nil, template: nil)
    @path = path || Rails.root.join('app', 'assets', 'labeltemplates')
    @template = template
  end

  def templates
    @templates ||= Hash[Dir.glob(@path.join("*.svg")).sort.map do |filename|
      [File.basename(filename, '.svg'), filename]
    end]
  end

  def list
    templates.keys
  end

  def filename
    File.basename(template_path(@template))
  end

  def template(data = {})
    LabelTemplate.new(template_file, data).generate
  end

  private
  def template_path(name = DEFAULT)
    templates.fetch(name) { templates[DEFAULT] }
  end

  def template_file
    IO.read template_path(@template)
  end
end