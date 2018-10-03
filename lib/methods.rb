def welcome
  puts "
        Welcome to myBrews, #{capitalize($name)}
        Please enter a number (1-7):
        1. Add New Coffee
        2. See All Coffee
        3. Add to Favorites
        4. Bring Up Favorites
        5. Get a Suggestion
        6. Search Coffees
        7. Exit"
end

def get_login

  puts "Welcome to myBrews!"
  puts "==================="

  puts "Please enter full name to login"
  $name = gets.chomp.downcase

  puts "Please enter a password"
  $password = gets.chomp.downcase


  while $name.split.count < 2 && $name.match(" ") == nil && $name.count("0-9") != 0
    puts "Not a valid name. Please enter full name."
    get_login
  end

  User.find_or_create_by(name: $name, password: $password)

end

def get_user
  User.find_by(name: $name, password: $password)
end

def add_new_coffee
  inputs = []
  menu_message
  user_id = User.find_by(name: $name, password: $password).id

  request = ["Please enter a coffee name", "Where did you get it?", "How did it taste?", "How much did it cost? (Enter Number)"]
  request.each do |request|
    puts request
    input = gets.chomp.downcase

    if input == 'menu'
      welcome
      break
    else
      until input.empty? == false
        puts "Please enter a valid input"
        input = gets.chomp
      end
    end
    inputs << input
  end

  if inputs.count == 4
    while inputs[3].to_f == 0
      puts "Please enter a valid number for cost"
      inputs[3] = gets.chomp
    end
    Coffee.create(name: capitalize(inputs[0]), shop_name: capitalize(inputs[1]), taste: inputs[2], cost: inputs[3])
    MyCoffee.create(user_id: user_id, coffee_id: Coffee.last.id)
    puts "Thanks for letting me know!"
    welcome
  end
end

def see_all_coffees

  if get_user.coffee_names.empty?
    puts "No coffees!"
  else
    puts "Here are your coffees:", ""
    get_user.coffee_names.each {|coffee_name| puts "#{coffee_name}"}
  end
  welcome
end

def add_to_favorites
  menu_message
  puts "Please enter the coffee's name"
  coffee_input = gets.chomp.downcase
  if coffee_input == "menu"
    welcome
  else
    get_user.coffees.each do |coffee|
      if coffee.name.downcase == coffee_input
        coffee.favorites = true
        coffee.save
        puts "Added to favorites!"
      else
        puts "", "Coffee not found"
        break
      end
    end
    welcome
  end
end

def bring_up_favorites
  puts "You love this coffee(s):", ""
  get_user.coffees.select {|coffee_name| coffee_name.favorites == true}.each {|fave_coffee| puts fave_coffee.name}
  welcome
end

def suggestion
  puts menu_message
  puts "How much do you want to pay? (Enter Number)"
  cost = gets.chomp
  if cost == "menu"
    welcome
  else
    until cost.to_f > 0.0
      puts "Please enter a valid number for cost"
      suggestion
    end

    puts "Maybe try this:"
    suggestion = Coffee.new(name: Faker::Coffee.blend_name, shop_name: Faker::Hipster.word.capitalize + "'s", cost: rand(1..cost.to_f).round(2), taste: Faker::Coffee.notes)

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

      user_id = User.find_by(name: $name, password: $password).id

      MyCoffee.create(user_id: user_id, coffee_id: Coffee.last.id)
      puts "Saved"
    else
      puts "It vanished!"
    end
    welcome
  end
end

def search_coffees

  inputs = []
  menu_message

  requests = ["What coffee would you like to search", "Which coffee shop?"]
  requests.each do |request|
    puts request
    input = gets.chomp.downcase
    if input == 'menu'
        welcome
        break
    else
      until input.empty? == false
        puts "Please enter a valid input"
        input = gets.chomp
      end
    end
    inputs << input
  end

    if inputs.count == 2
      found_coffee = Coffee.find_by(name: capitalize(inputs[0]), shop_name: capitalize(inputs[1]))

      if found_coffee == nil
        puts "Sorry, no coffee by that name!"
      else
        puts "
              Name: #{found_coffee.name}
              Shop Name: #{found_coffee.shop_name}
              Price: $#{found_coffee.cost}
              "
      end
      welcome
    end
end

def capitalize(name)
  if name.split(' ').size > 1
    name.split.map {|x| x.capitalize!}.join(' ')
  else
    name.capitalize!
  end
end

# def menu(method, answer)
#   if answer == "y"
#     welcome
#   elsif answer == "n"
#     send(method)
#   end
# end

def menu_message
  puts "If you would like to return to menu, please enter 'menu'"
end

def run
  get_login
  welcome
  loop do
    option = gets.chomp
    case option
    when "1"
      add_new_coffee
    when "2"
      see_all_coffees
    when "3"
      add_to_favorites
    when "4"
      bring_up_favorites
    when "5"
      suggestion
    when "6"
      search_coffees
    when "7"
      puts "Goodbye!"
      break
    else
      puts "Please enter a valid command."
    end
  end
end
