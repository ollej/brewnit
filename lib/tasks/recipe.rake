namespace :recipe do
  desc "Update recipe values."
  task :update => :environment do
    Recipe.all.each do |recipe|
      recipe.extract_details
      recipe.save!
    end
  end

  desc "Delete unconfirmed users"
  task :delete_unconfirmed_users => :environment do
    User.unconfirmed.destroy_all
  end
end
