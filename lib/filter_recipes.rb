class FilterRecipes
  SGMIN = "1.000"
  SGMAX = "1.150"
  # X TODO: Change to search hash
  # X TODO: Store search hash in session
  # X TODO: Populate search form with prior search
  # TODO: Add search link to menu
  # X TODO: Show droplist with styles
  # TODO: search by user with autocomplete
  # TODO: Search by value ranges
  # TODO: Search by date range
  # X TODO: Clear search
  # X TODO: Search all fields by default
  # TODO: Search comments
  def initialize(scope, hash)
    @scope = scope
    @hash = hash
  end

  def query?
    !@hash.empty?
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
      @scope.unsafe_search(query)
    else
      @scope.search(query)
    end
  end

  def query
    ands = []
    ands << { query: @hash[:q] } if @hash[:q].present?
    ands << { style_name: @hash[:style] } if @hash[:style].present?
    if @hash[:ogfrom].present?
      ands << { og: { gt: @hash[:ogfrom] || SGMIN } }
    end
    if @hash[:ogto].present?
      ands << { og: { lt: @hash[:ogto] || SGMAX } }
    end
    if @hash[:fgfrom].present?
      ands << { fg: { gt: @hash[:fgfrom] || SGMIN } }
    end
    if @hash[:fgto].present?
      ands << { fg: { lt: @hash[:fgto] || SGMAX } }
    end
    {
      and: ands
    }
  end
end
