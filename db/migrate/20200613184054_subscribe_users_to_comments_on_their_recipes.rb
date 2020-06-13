class SubscribeUsersToCommentsOnTheirRecipes < ActiveRecord::Migration[6.0]
  def up
    Recipe.all.each do |recipe|
      puts "Subscribing #{recipe.user.email} to #{recipe.name}"
      recipe.commontator_thread.subscribe(recipe.user)
    end
  end
end
