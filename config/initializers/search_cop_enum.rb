class SearchCopGrammar::Attributes::Enum < SearchCopGrammar::Attributes::WithoutMatches
end

class SearchCop::Visitors::Visitor
  alias :visit_SearchCopGrammar_Attributes_Enum :visit_attribute
end

