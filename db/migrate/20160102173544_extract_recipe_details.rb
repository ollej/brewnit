class ExtractRecipeDetails < ActiveRecord::Migration[4.2]
  def up
    Recipe.all.each do |recipe|
      recipe.extract_details
      recipe.save!
    end
  end
end
