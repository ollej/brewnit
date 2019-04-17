class LabelTemplates
  DEFAULT = 'back-label'
  FILE_TYPES = {
    template: {
      dir: 'templates',
      extension: '.svg'
    },
    background: {
      dir: 'backgrounds',
      extension: '.png'
    },
    border: {
      dir: 'borders',
      extension: '.png'
    }
  }

  def initialize(path: nil, template: nil)
    @path = path || Rails.root.join('app', 'assets', 'labels')
    @template = template
  end

  def templates
    @templates ||= files(FILE_TYPES[:template])
  end

  def backgrounds
    @backgrounds ||= files(FILE_TYPES[:background])
  end

  def borders
    @borders ||= files(FILE_TYPES[:border])
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
  def files(dir:, extension:)
    Rails.logger.debug { "dir: #{dir} extension: #{extension}" }
    Rails.logger.debug { @path.join(dir, "*#{extension}") }
    Hash[Dir.glob(@path.join(dir, "*#{extension}")).sort.map do |filename|
      [File.basename(filename, extension), filename]
    end]
  end

  def template_path(name)
    begin
      templates.fetch(name)
    rescue KeyError
      raise LabelTemplateNotFound.new("LabelTemplate not found: #{name}")
    end
  end

  def template_file
    IO.read template_path(@template)
  end

  class LabelTemplateNotFound < ActionController::RoutingError; end
end
