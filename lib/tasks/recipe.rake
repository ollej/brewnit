namespace :recipe do
  desc 'Update recipe values.'
  task :update => :environment do
    Recipe.unscoped.all.each do |recipe|
      puts "Extracting recipe details for Recipe##{recipe.id}"
      if recipe.beerxml.present?
        BeerxmlImport.new(recipe, recipe.beerxml).run
        recipe.save!
      end
    end
  end

  desc 'Delete unconfirmed users'
  task :delete_unconfirmed_users => :environment do
    User.unconfirmed.destroy_all
  end

  desc 'Import SHBF recipes'
  task :import_shbf => :environment do
    ShbfClient.new(2017).import
  end
end
