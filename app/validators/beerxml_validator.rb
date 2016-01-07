class BeerxmlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      record.beerxml_details
    rescue NRB::BeerXML::Parser::InvalidRecordError => e
      record.errors[attribute] << (options[:message] || I18n.t(:'activerecord.errors.models.recipe.attributes.beerxml.invalid'))
      e.errors.each do |field, msgs|
        error_field = "beerxml_#{field}".to_sym
        msgs.each do |msg|
          record.errors[error_field] << msg
        end
      end

    end
  end
end
