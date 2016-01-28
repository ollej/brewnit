namespace :recipe do
  desc "Update recipe values."
  task :update => :environment do
    Recipe.all.each do |recipe|
      recipe.extract_details
      recipe.save!
    end
  end
end
