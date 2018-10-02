class CreateCoffees < ActiveRecord::Migration[5.0]
  def change
    create_table :coffees do |t|
      t.string :name
      t.string :shop_name
      t.float :cost
      t.string :taste
      t.boolean :favorites, default: false
    end
  end
end
