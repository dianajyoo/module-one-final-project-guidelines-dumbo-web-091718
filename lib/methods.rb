def welcome
  puts "
        Welcome to myBrews
        Please enter a number (1-8):
        1. Create Profile
        2. Add New Coffee
        3. See All Coffee
        4. Add to Favorites
        5. Bring Up Favorites
        6. Get a Suggestion
        7. Search Coffees
        8. Exit"
end

def get_login

  puts "Welcome to myBrews!"
  puts "==================="

  puts "Please enter full name to login"
  $name = gets.chomp.downcase

  puts "Please enter a password"
  password = gets.chomp.downcase

  until $name.split.count < 2 && $name.match(" ") == nil && $name.count("0-9") != 0
    puts "Not a valid name. Please enter full name."
    get_login
  end

  User.find_or_create_by(name: $name, password: password)

end

def get_welcome

  if $name != "menu"
    welcome
  end

end


def return_to_menu

  if $name == "menu"
    menu
  else
    welcome
  end

end

def add_new_coffee
  puts "Who drank this coffee? (Please enter name)"
  user = gets.chomp.downcase
  if user == "menu"
    menu
  end

  if User.find_by(name: user) == nil
    puts "Please create a profile"
    create_profile
  else
    user_id = User.find_by(name: user).id
  end

  if user != "menu"
    request = ["Please enter a coffee name", "Where did you get it?", "How much did it cost?", "How did it taste?"]
    inputs = request.map do |request|
      puts request
      input = gets.chomp
      until input.empty? == false
        puts "Please enter a valid input"
        input = gets.chomp
      end
    end
    Coffee.create(name: capitalize(inputs[0]), shop_name: capitalize(inputs[1]), cost: inputs[2], taste: inputs[3])
    MyCoffee.create(user_id: user_id, coffee_id: Coffee.last.id)
    puts "Thanks for letting me know!"
  end
end

def see_all_coffees
  puts "What is your name?"
  user_input = gets.chomp.downcase
  if user_input == "menu"
    menu
  end

  if user_input != "menu"
    user = User.find_by(name: user_input)
    puts "Here are your coffees:"
    user.coffee_names.each {|coffee_name| puts "#{coffee_name}"}
  end
end

def add_to_favorites
  puts "What is your name?"
  user_input = gets.chomp.downcase
  if user_input == "menu"
    menu
  end

  if user_input != "menu"
    puts "Please enter the coffee's name"
    coffee_input = gets.chomp
    if coffee_input == "menu"
      menu
    end

    user = User.find_by(name: user_input)

    user.coffees.each do |coffee|
      if coffee.name == coffee_input
        coffee.favorites = true
        coffee.save
      end
    end
  end
end

def bring_up_favorites
  puts "What is your name?"
  user_input = gets.chomp.downcase
  if user_input == "menu"
    menu
  end

  if user_input != "menu"
    user = User.find_by(name: user_input)

    puts "You love this coffee:"

    user.coffees.select {|coffee_name| coffee_name.favorites == true}.each {|fave_coffee| puts fave_coffee.name}
  end
end

def suggestion
  puts "How much do you want to pay? (Enter Number)"
  cost = gets.chomp.to_f
  if cost == "menu"
    menu
  end

  if cost != "menu"
    puts "Maybe try this:"
    suggestion = Coffee.new(name: Faker::Coffee.blend_name, shop_name: Faker::Hipster.word.capitalize + "'s", cost: rand(1..cost).round(2), taste: Faker::Coffee.notes)

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
end

def search_coffees
  puts "What coffee would you like to search"
  coffee = gets.chomp
  if coffee == "menu"
    menu
  end

  if coffee != "menu"
    found_coffee = Coffee.where(name: capitalize(coffee)).distinct

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
end

def capitalize(name)
  if name.split(' ').size > 1
    name.split.map {|x| x.capitalize!}.join(' ')
  else
    name.capitalize!
  end
end

def menu
  puts "Would you like to go back to the menu? (Y/N)"
  input = gets.chomp.downcase
  if input == "y"
    welcome
  end
end

def run
  welcome
  loop do
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
