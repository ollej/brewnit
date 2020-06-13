module EventRecipesHelper
  def registration_message(recipe)
    if can_modify?(@event)
      recipe.registration_message_for(@event)
    end
  end
end
