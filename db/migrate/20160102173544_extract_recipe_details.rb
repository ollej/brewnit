class ExtractRecipeDetails < ActiveRecord::Migration
  def up
    Recipe.all.each do |recipe|
      recipe.extract_details
      recipe.save!
    end
  end
end
