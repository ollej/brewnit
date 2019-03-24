namespace :recipe do
  desc 'Update recipe values.'
  task :update => :environment do
    Recipe.unscoped.all.each do |recipe|
      puts "Extracting recipe details for Recipe##{recipe.id}"
      if recipe.beerxml.present?
        beer_recipe = BeerxmlParser.new(recipe.beerxml).recipe
        BeerxmlImport.new(recipe, beer_recipe).run
        recipe.save!
      end
    end
  end

  desc 'Delete unconfirmed users'
  task :delete_unconfirmed_users => :environment do
    User.unconfirmed.destroy_all
  end

  desc 'Import SHBF recipes'
  task :import_shbf, [:year] => :environment do |t, args|
    args.with_defaults(year: 2018)
    ShbfClient.new(args.year).import
  end

  desc 'Update recipes_count on users'
  task :update_recipes_count => :environment do
    User.find_each { |user| User.reset_counters(user.id, :recipes) }
  end
end
