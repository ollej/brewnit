module RecipesHelper
  def avatar_for(recipe)
    if recipe.user.present? && recipe.user.avatar.present?
      recipe.user.avatar
    elsif recipe.user.present? && recipe.user.email.present?
      hash = Digest::MD5.hexdigest(recipe.user.email)
      "https://secure.gravatar.com/avatar/#{hash}?s=100&d=retro"
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
      cls << 'email-item-selected'
    end
    cls.join(' ')
  end

  def badge(content, type=nil)
    css = type.nil? ? 'pure-badge' : "pure-badge-#{type}"
    %Q{<span class="#{css}">#{content}</span>}.html_safe
  end

  def visibility_badge(recipe)
    if recipe.public?
      badge(I18n.t(:'common.public'), 'public')
    else
      badge(I18n.t(:'common.private'), 'private')
    end
  end
end
