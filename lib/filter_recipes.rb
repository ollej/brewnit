class FilterRecipes
  OGMIN = "1.020"
  OGMAX = "1.150"
  FGMIN = "1.000"
  FGMAX = "1.060"
  IBUMIN = "0"
  IBUMAX = "150"
  COLORMIN = "0"
  COLORMAX = "150"
  ABVMIN = "0"
  ABVMAX = "25"
  # X TODO: Change to search hash
  # X TODO: Store search hash in session
  # X TODO: Populate search form with prior search
  # TODO: Add search link to menu
  # X TODO: Show droplist with styles
  # TODO: search by user with autocomplete
  # X TODO: Search by value ranges
  # TODO: Search by date range
  # X TODO: Clear search
  # X TODO: Search all fields by default
  # TODO: Search comments

  def initialize(scope, hash)
    @scope = scope
    @hash = hash
  end

  def query?
    !query.empty?
  end

  def resolve
    if query?
      search
    else
      @scope
    end
  end

  def search
    Rails.logger.debug { "Searching with query: #{query.inspect}" }
    if Rails.env.development?
      @scope.unsafe_search(and: query)
    else
      @scope.search(and: query)
    end
  end

  def query
    @query ||= begin
      query = []
      query << { query: @hash[:q] } if @hash[:q].present?
      query << { style_name: @hash[:style] } if @hash[:style].present?
      if @hash[:ogfrom].present? && @hash[:ogfrom] != OGMIN
        query << { og: { gt: @hash[:ogfrom] } }
      end
      if @hash[:ogto].present? && @hash[:ogto] != OGMAX
        query << { og: { lt: @hash[:ogto] } }
      end
      if @hash[:fgfrom].present? && @hash[:fgfrom] != FGMIN
        query << { fg: { gt: @hash[:fgfrom] } }
      end
      if @hash[:fgto].present? && @hash[:fgto] != FGMAX
        query << { fg: { lt: @hash[:fgto] } }
      end
      if @hash[:ibufrom].present? && @hash[:ibufrom] != IBUMIN
        query << { ibu: { gt: @hash[:ibufrom] } }
      end
      if @hash[:ibuto].present? && @hash[:ibuto] != IBUMAX
        query << { ibu: { lt: @hash[:ibuto] } }
      end
      if @hash[:colorfrom].present? && @hash[:colorfrom] != COLORMIN
        query << { color: { gt: @hash[:colorfrom] } }
      end
      if @hash[:colorto].present? && @hash[:colorto] != COLORMAX
        query << { color: { lt: @hash[:colorto] } }
      end
      if @hash[:abvfrom].present? && @hash[:abvfrom] != ABVMIN
        query << { abv: { gt: @hash[:abvfrom] } }
      end
      if @hash[:abvto].present? && @hash[:abvto] != ABVMAX
        query << { abv: { lt: @hash[:abvto] } }
      end
      query
    end
  end
end
