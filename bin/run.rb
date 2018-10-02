require_relative '../config/environment'
require 'pry'

def welcome
  puts "
        Welcome to Coffee App
        Please enter a number (1-7):
        1. Create Profile
        2. Add New Coffee
        3. See All Coffee
        4. Add to Favorites
        5. Bring Up Favorites
        6. Get a Suggestion
        7. Exit"
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

  puts "Here are your coffees:"
  user.coffee_names.each {|coffee_name| puts "#{coffee_name}"}
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
      coffee.save
    end
  end
end

def bring_up_favorites
  puts "What is your name?"
  user_input = gets.chomp

  user = User.find_by(name: user_input)

  puts "You love this coffee:"

  user.coffees.select {|coffee_name| coffee_name.favorites == true}.each {|fave_coffee| puts fave_coffee.name}
end

def run
  loop do
    welcome
    option = gets.chomp
    case option
    when "1"
      create_profile
    when "2"
      add_new_coffee
    when "3"
      see_all_coffees
    when "4"
      add_to_favorites
    when "5"
      bring_up_favorites
    # when "6"
    #   get_a_suggestion
    when "7"
      puts "Goodbye!"
      break
    end
  end
end

run
