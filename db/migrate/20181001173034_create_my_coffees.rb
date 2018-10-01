class CreateMyCoffees < ActiveRecord::Migration[5.0]
  def change
    create_table :my_coffees do |t|
      t.integer :user_id
      t.integer :coffee_id
    end
  end
end
