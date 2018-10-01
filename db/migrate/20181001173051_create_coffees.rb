class CreateCoffees < ActiveRecord::Migration[5.0]
  def change
    create_table :coffees do |t|
      t.string :blend_name
      t.string :origin
      t.string :variety
      t.string :notes
      t.string :coffee_intensifier
    end
  end
end
