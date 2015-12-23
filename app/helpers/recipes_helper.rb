module RecipesHelper
  def avatar_for(recipe)
    if recipe.user.present? && avatar = recipe.user.avatar_image
      avatar
    else
      hash = Digest::MD5.hexdigest("#{recipe.id}/#{recipe.name}")
      "http://api.adorable.io/avatars/100/#{hash}.png"
    end
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
    cls.join(' ')
  end

  def icon(type=nil)
    %{<i class="fa fa-#{type}"></i>} if type
  end

  def badge(content, type=nil, icon=nil)
    css = type.nil? ? 'pure-badge' : "pure-badge-#{type}"
    %Q{<span class="#{css}">#{icon(icon)}#{content}</span>}.html_safe
  end

  def visibility_badge(recipe)
    if recipe.public?
      badge(I18n.t(:'common.public'), 'public')
    else
      badge(I18n.t(:'common.private'), 'private')
    end
  end

  def comments_badge(recipe)
    badge(I18n.t(:'recipes.comments_count', count: recipe.comments), 'comments', 'comments')
  end

  def likes_badge(recipe)
    badge(I18n.t(:'recipes.votes_count', count: recipe.get_likes.size), 'likes', 'thumbs-up')
  end

  def like_tag(recipe, user)
    if user.liked? recipe
      link_to unlike_recipe_path(recipe), method: :delete, remote: true, class: 'thumb-like like-link pure-button secondary-button' do
        (content_tag(:i, '', class: 'fa fa-thumbs-up') + ' ' + I18n.t(:'recipes.likes.unlike')).html_safe
      end
    else
      link_to like_recipe_path(recipe), method: :post, remote: true, class: 'thumb-unlike like-link pure-button secondary-button' do
        (content_tag(:i, '', class: 'fa fa-thumbs-o-up') + ' ' + I18n.t(:'recipes.likes.like')).html_safe
      end
    end
  end
end
