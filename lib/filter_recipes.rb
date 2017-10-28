class FilterRecipes
  SORT_FIELDS = {
    I18n.t(:'common.search.order.date') => 'created_at',
    I18n.t(:'common.search.order.name') => 'name',
    #I18n.t(:'common.search.order.comments') => 'comments',
    #I18n.t(:'common.search.order.likes') => 'likes',
    I18n.t(:'common.search.order.downloads') => 'downloads',
    I18n.t(:'common.search.order.abv') => 'abv',
    I18n.t(:'common.search.order.ibu') => 'ibu',
    I18n.t(:'common.search.order.style') => 'style',
    I18n.t(:'common.search.order.likes') => 'likes',
  }

  SORT_ORDER = {
    created_at: 'recipes.created_at desc',
    name: 'recipes.name asc',
    downloads: 'recipes.downloads desc',
    abv: 'recipes.abv desc',
    ibu: 'recipes.ibu desc',
    style: 'recipes.style_name asc',
    likes: 'recipes.cached_votes_up desc'
  }

  PAGE_LIMIT = 50

  OGMIN = '1.020'
  OGMAX = '1.150'
  FGMIN = '1.000'
  FGMAX = '1.060'
  IBUMIN = '0'
  IBUMAX = '150'
  COLORMIN = '0'
  COLORMAX = '150'
  ABVMIN = '0'
  ABVMAX = '25'

  FILTERS = {
    og: { from: :ogfrom, to: :ogto, min: OGMIN, max: OGMAX },
    fg: { from: :fgfrom, to: :fgto, min: FGMIN, max: FGMAX },
    ibu: { from: :ibufrom, to: :ibuto, min: IBUMIN, max: IBUMAX },
    color: { from: :colorfrom, to: :colorto, min: COLORMIN, max: COLORMAX },
    abv: { from: :abvfrom, to: :abvto, min: ABVMIN, max: ABVMAX },
  }

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
  # TODO: Namespace search query params to avoid collisions

  def initialize(scope, hash)
    @scope = scope
    @hash = hash
    Rails.logger.debug { "FilterRecipes: #{@hash.inspect}" }
  end

  def query?
    !query.empty?
  end

  def total_count
    @total_count ||= resolved.limit(nil).count
  end

  def resolved
    @resolved ||= resolve
  end

  def resolve
    scope = if query?
      search
    else
      @scope
    end
    scope.order(sort_order)
  end

  def sort_order
    Rails.logger.debug { "sort_order: #{@hash[:sort_order]}" }
    order = SORT_ORDER[@hash[:sort_order].to_sym] if @hash[:sort_order].present?
    order ||= SORT_ORDER[:created_at]
    Rails.logger.debug { "order: #{order}" }
    order
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
      query << { equipment: @hash[:equipment] } if @hash[:equipment].present?
      query << { event: @hash[:event] } if @hash[:event].present?
      query << { event_id: @hash[:event_id] } if @hash[:event_id].present?
      add_filters(query)
      query
    end
  end

  def add_filters2(query)
    FILTERS.each do |filter, values|
      from_field = @hash[values[:from]]
      if from_field.present && from_field != min
        hash = {}
        hash[filter] = { gt: from_field }
        query << hash
      end
      to_field = @hash[values[:to]]
      if to_field.present && to_field != max
        hash = {}
        hash[filter] = { lt: to_field }
        query << hash
      end
    end

  end

  def add_filters(query)
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
