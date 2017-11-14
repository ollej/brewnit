module EventRecipesHelper
  def registration_message(recipe)
    if user_signed_in? && current_user.can_modify?(@event)
      recipe.registration_message_for(@event.id)
    end
  end
end
