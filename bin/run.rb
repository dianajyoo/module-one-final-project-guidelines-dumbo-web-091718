require_relative '../config/environment'
require 'pry'

def welcome
  puts "
        Welcome to myBrews
        Please enter a number (1-7):
        1. Create Profile
        2. Add New Coffee
        3. See All Coffee
        4. Add to Favorites
        5. Bring Up Favorites
        6. Get a Suggestion
        7. Search Coffees
        8. Exit"
end

def create_profile
  loop do
    puts "What is your full name?"
    name = gets.chomp.downcase
    if name.to_i.class == Fixnum && name.to_i > 0
      puts "Not a valid name. Please try again."
    elsif name.split.count < 2
      puts "Please enter your full name."
    else
      User.create(name: name)
      puts "Hi, #{name.split.map(&:capitalize).join(' ')}"
      break
    end
  end
end

def add_new_coffee
  puts "Who drank this coffee? (Please enter name)"
  user = gets.chomp.downcase

  if User.find_by(name: user) == nil
    puts "Please create a profile"
    create_profile
  else
    user_id = User.find_by(name: user).id
  end

  puts "Please enter a coffee name"
  name = gets.chomp

  puts "Where did you get it?"
  shop_name = gets.chomp

  puts "How much did it cost?"
  cost = gets.chomp.to_f

  puts "Please rate from 1-5"
  rating = gets.chomp

  puts "How did it taste?"
  taste = gets.chomp

  Coffee.create(name: capitalize(name), shop_name: capitalize(shop_name), cost: cost, rating: rating, taste: taste)
  MyCoffee.create(user_id: user_id, coffee_id: Coffee.last.id)
  puts "Thanks for letting me know!"
end

def see_all_coffees
  puts "What is your name?"
  user_input = gets.chomp.downcase

  user = User.find_by(name: user_input)

  puts "Here are your coffees:"
  user.coffee_names.each {|coffee_name| puts "#{coffee_name}"}
end

def add_to_favorites
  puts "What is your name?"
  user_input = gets.chomp.downcase

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
  user_input = gets.chomp.downcase

  user = User.find_by(name: user_input)

  puts "You love this coffee:"

  user.coffees.select {|coffee_name| coffee_name.favorites == true}.each {|fave_coffee| puts fave_coffee.name}
end

def suggestion
  puts "How much do you want to pay?"
  cost = gets.chomp.to_f

  puts "Maybe try this:"
  suggestion = Coffee.new(name: Faker::Coffee.blend_name, shop_name: Faker::Hipster.word.capitalize + "'s", cost: rand(1..cost).round(2), taste: Faker::Coffee.notes, rating: 3)

  puts "
        Name: #{suggestion.name}
        Shop Name: #{suggestion.shop_name}
        Price: $#{suggestion.cost}
        Taste: #{suggestion.taste}
        "

  puts "Do you want to save this? (Y/N)"
  option = gets.chomp.downcase

  if option == "y"
    suggestion.save

    puts "Who is saving this coffee? (Please enter name)"
    user = gets.chomp.downcase
    user_id = User.find_by(name: user).id

    MyCoffee.create(user_id: user_id, coffee_id: Coffee.last.id)
    puts "Saved"
  else
    puts "It vanished!"
  end
end

def search_coffees
  puts "What coffee would you like to search"
  coffee = gets.chomp
  found_coffee = Coffee.where(name: capitalize(coffee)).uniq

  if found_coffee == nil
    puts "Sorry, no coffee by that name!"
    search_coffees
  elsif found_coffee.count == 1
    puts "
          Name: #{found_coffee.name}
          Shop Name: #{found_coffee.shop_name}
          Price: $#{found_coffee.cost}
          "
  elsif found_coffee.count > 1
    found_coffee.each do |coffee|
      puts "
            Name: #{coffee.name}
            Shop Name: #{coffee.shop_name}
            Price: $#{coffee.cost}
            "
    end
  end
end

def capitalize(name)
  if name.split(' ').size > 1
    name.split.map {|x| x.capitalize!}.join(' ')
  else
    name.capitalize!
  end
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
    when "6"
      suggestion
    when "7"
      search_coffees
    when "8"
      puts "Goodbye!"
      break
    else
      puts "Please enter a valid command."
    end
  end
end

run
