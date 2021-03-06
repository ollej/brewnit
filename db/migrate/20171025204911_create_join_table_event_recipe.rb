class CreateJoinTableEventRecipe < ActiveRecord::Migration[4.2]
  def change
    create_join_table :events, :recipes do |t|
      t.index [:event_id, :recipe_id]
      t.index [:recipe_id, :event_id]
    end
  end
end
