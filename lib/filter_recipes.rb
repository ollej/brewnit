class FilterRecipes
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
  def initialize(scope, query)
    @scope = scope
    @query = query
  end

  def query?
    !@query.empty?
  end

  def resolve
    if query?
      search
    else
      @scope
    end
  end

  def search
    Rails.logger.debug { "Searching with query: #{@query.inspect}" }
    if Rails.env.development?
      @scope.unsafe_search(@query)
    else
      @scope.search(@query)
    end
  end

  def self.parse_params(params)
    hash = {}
    hash[:query] = params[:q] if params[:q].present?
    hash[:style_name] = params[:style] if params[:style].present?
    hash
  end
end
