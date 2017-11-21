namespace :recipe do
  desc "Update recipe values."
  task :update => :environment do
    Recipe.unscoped.all.each do |recipe|
      puts "Extracting recipe details for Recipe##{recipe.id}"
      recipe.extract_beerxml_details
      recipe.save!
    end
  end

  desc "Delete unconfirmed users"
  task :delete_unconfirmed_users => :environment do
    User.unconfirmed.destroy_all
  end
end
