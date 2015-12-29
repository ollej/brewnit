class BeerxmlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      record.beerxml_details
    rescue NRB::BeerXML::Parser::InvalidRecordError
      record.errors[attribute] << (options[:message] || I18n.t(:'activerecord.errors.models.recipe.attributes.beerxml.invalid'))
    end
  end
end
