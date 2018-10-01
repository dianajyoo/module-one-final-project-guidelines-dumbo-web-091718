class User < ActiveRecord::Base
  has_many :my_coffees
  has_many :coffees, through: :my_coffees

  def coffee_names
    self.coffees.map do |coffee|
      coffee.name
    end
  end
end
