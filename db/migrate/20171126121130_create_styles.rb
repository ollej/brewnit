class CreateStyles < ActiveRecord::Migration[5.1]
  def change
    create_table :styles do |t|
      t.string :name, null: false, default: ''
      t.text :description, null: false, default: ''
      t.string :category, null: false, default: ''
      t.integer :number, null: false
      t.string :letter, null: false
      t.text :aroma, null: false, default: ''
      t.text :appearance, null: false, default: ''
      t.text :flavor, null: false, default: ''
      t.text :texture, null: false, default: ''
      t.text :examples, null: false, default: ''
      t.text :summary, null: false, default: ''
      t.numeric :og_min, null: false, default: 0
      t.numeric :og_max, null: false, default: 0
      t.numeric :fg_min, null: false, default: 0
      t.numeric :fg_max, null: false, default: 0
      t.numeric :ebc_min, null: false, default: 0
      t.numeric :ebc_max, null: false, default: 0
      t.numeric :ibu_min, null: false, default: 0
      t.numeric :ibu_max, null: false, default: 0
      t.numeric :abv_min, null: false, default: 0
      t.numeric :abv_max, null: false, default: 0
      t.string 'style_guide', null: false, default: '', index: true

      t.timestamps
    end
  end
end
