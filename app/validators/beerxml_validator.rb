class BeerxmlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      doc = Nokogiri::XML(record.beerxml)
      doc.encoding = 'UTF-8'
      record.beerxml = doc.to_s
      BeerxmlParser.new(record.beerxml).recipe
    rescue Nokogiri::XML::SyntaxError => e
      Rails.logger.error { "BeerXML syntax error: #{e.message}" }
      record.errors[attribute] << (options[:message] || I18n.t(:'activerecord.errors.models.recipe.attributes.beerxml.parse_error'))
    rescue NRB::BeerXML::Parser::InvalidRecordError => e
      Rails.logger.error { "BeerXML invalid error: #{e.message}" }
      record.errors[attribute] << (options[:message] || I18n.t(:'activerecord.errors.models.recipe.attributes.beerxml.invalid'))
      e.errors.each do |field, msgs|
        error_field = %w(attribute field).join('_').to_sym
        msgs.each do |msg|
          record.errors[error_field] << msg
        end
      end
    end
  end
end
