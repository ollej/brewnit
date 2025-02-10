module RecipesHelper
  def media_main_tag(recipe)
    recipe_avatar(recipe, 160, 120, :small)
  end

  def item_classes_for(recipe, current_user=nil, current_recipe=nil)
    cls = []
    if recipe.public?
      cls << 'recipe-item-public'
    else
      cls << 'recipe-item-private'
    end
    if recipe.user == current_user
      cls << 'recipe-item-own'
    end
    if current_recipe.present? && current_recipe == recipe
      cls << 'recipe-item-selected'
    end
    if recipe.placement.present?
      cls << 'recipe-item-winner'
    end
    if !recipe.complete?
      cls << 'recipe-item-incomplete'
    end
    cls.join(' ')
  end

  def visibility_badge(recipe)
    if recipe.public?
      badge(I18n.t(:'common.public'), type: 'public', icon: 'lock-open')
    else
      badge(I18n.t(:'common.private'), type: 'private', icon: 'lock')
    end
  end

  def comments_badge(recipe)
    badge(I18n.t(:'recipes.comments_count', count: recipe.comment_count), type: 'comments', icon: 'comments', class: 'badge-link')
  end

  def likes_badge(recipe)
    badge(
      I18n.t(:'recipes.votes_count', count: recipe.get_likes.size),
      type: 'likes',
      icon: 'thumbs-up',
      class: 'badge-link',
      tooltip: recipe.likes_list
    )
  end

  def downloads_badge(recipe)
    badge(I18n.t(:'recipes.downloads_count', count: recipe.downloads), type: 'downloads', icon: 'bolt', class: 'badge-link')
  end

  def brewlogs_badge(recipe)
    badge(
      I18n.t(:'brewlogs.count', count: recipe.brew_logs_count),
      type: 'brewlogs',
      icon: 'clipboard-list',
      class: 'badge-link',
      tooltip: recipe.brew_logs_list
    )
  end

  def like_tag(recipe, user)
    if user.liked? recipe
      link_to unlike_recipe_path(recipe), method: :delete, remote: true,
        class: 'thumb-like like-link pure-button secondary-button',
        data: tooltip_data(I18n.t(:'recipes.likes.unlike_description')) do
        concat icon('thumbs-up')
        concat ' ' + I18n.t(:'recipes.likes.unlike')
      end
    else
      link_to like_recipe_path(recipe), method: :post, remote: true,
        class: 'thumb-unlike like-link pure-button secondary-button',
        data: tooltip_data(I18n.t(:'recipes.likes.like_description')) do
        concat icon('thumbs-up')
        concat ' ' + I18n.t(:'recipes.likes.like')
      end
    end
  end

  def format_abv(abv)
    precision = abv > 10 ? 0 : 1
    number_to_percentage(abv, precision: precision)
  end

  def trans(field, options={})
    options[:default] ||= [field, '']
    options[:scope] ||= :beerxml
    I18n.t(field, **options)
  end

  def format_sg(value)
    number_with_precision(value, precision: 3, separator: '.')
  end

  def misc_amount(misc)
    if misc.large_amount?
      precision = misc.weight? ? 0 : 2
      number_with_precision(misc.amount, precision: precision)
    else
      precision = misc.type == 'Water Agent' ? 2 : 0
      number_with_precision(misc.amount * 1000, precision: precision)
    end
  end

  def format_text(text)
    if text.present? && text.kind_of?(String)
      simple_format(text)
    end
  end

  def format_html(html)
    if html.present? && html.kind_of?(String)
      simple_format(html, {}, sanitize: false)
    end
  end
end
