require_relative '../config/environment'
require 'pry'

def welcome
  puts "Welcome to Coffee App"
  puts "Please select an option:"
  puts "1. Create Profile"
  puts "2. Add New Coffee"
  puts "3. See All Coffee"
  puts "4. Add to Favorites"
  puts "5. Bring Up Favorites"
  puts "6. Get a Suggestion"
  option = gets.chomp
end

def create_profile
  puts "What is your full name?"
  name = gets.chomp
  User.create(name: name)
  puts "Hi, #{name}"
end

def add_new_coffee
  puts "Who drank this coffee? (Please enter name)"
  user = gets.chomp
  user_id = User.find_by(name: user).id

  puts "Please enter a name"
  name = gets.chomp

  puts "Where did you get it?"
  location = gets.chomp

  puts "How much did it cost?"
  cost = gets.chomp.to_f

  puts "Please rate from 1-5"
  rating = gets.chomp

  puts "How did it taste?"
  taste = gets.chomp

  Coffee.create(name: name, location: location, cost: cost, rating: rating, taste: taste)
  My_Coffee.create(user_id: user_id, coffee_id: Coffee.last.id)
  puts "Thanks for letting me know!"
end

def see_all_coffees
  puts "What is your name?"
  user_input = gets.chomp

  user = User.find_by(name: user_input)
  binding.pry

  puts "Here are your coffees:"
  user.coffee_names.each do |coffee_name|
    puts "#{coffee_name}"
  end
end

def add_to_favorites
  puts "What is your name?"
  user_input = gets.chomp

  puts "Please enter the coffee's name"
  coffee_input = gets.chomp

  user = User.find_by(name: user_input)

  user.coffees.each do |coffee|
    if coffee.name == coffee_input
      coffee.favorites = true
    end
  end
end

def bring_up_favorites
  puts "What is your name?"
  user_input = gets.chomp

  user = User.find_by(name: user_input)

  puts "You love this coffee:"

  user.coffees.select  {|coffee_name| coffee.favorites == true}.map {|fave_coffee| fave_coffee.name}
end

welcome
# create_profile
# add_new_coffee
# see_all_coffees
# add_to_favorites
bring_up_favorites
binding.pry
0
