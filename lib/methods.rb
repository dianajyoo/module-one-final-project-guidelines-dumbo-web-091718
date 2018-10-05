def run
  login_picture
  get_login
  welcome
end

def welcome
  Catpix::print_image "./media/images/coffee_black_back.png",
  :limit_x => 0.5,
  :limit_y => 0.5,
  :center_x => true,
  :center_y => true,
  :resolution => "high"

  prompt = TTY::Prompt.new

  choices = {
    "Add New Coffee" => -> do add_new_coffee end,
    "See Your Coffee" => -> do see_all_coffees end,
    "Add To Favorites" => -> do add_to_favorites end,
    "Bring Up Favorites" => -> do bring_up_favorites end,
    "Get A Suggestion" => -> do suggestion end,
    "Search Coffee Database" => -> do search_coffees end,
    "Quit" => -> do goodbye end,
    "" => -> do easter_egg end
    }


  prompt.select("Welcome to myBrews, #{capitalize($name)}", choices, cycle: true)
    menu.choice "Add New Coffee"
    menu.choice "See Your Coffee"
    menu.choice "Add to Favorites"
    menu.choice "Bring Up Favorites"
    menu.choice "Get a Suggestion"
    menu.choice "Search Coffee Database"
    menu.choice "Quit"
    menu.choice ""
end

def login_picture
  pid = fork{exec 'afplay', './media/music/words_fail.m4a'}
  Catpix::print_image "./media/images/welcome.jpg",
  :limit_x => 1.0,
  :limit_y => 1.0,
  :center_x => true,
  :center_y => true,
  :resolution => "high"

  pastel = Pastel.new
  puts pastel.cyan.bold("Welcome to myBrews!")
  puts pastel.cyan.bold("=====================")
  puts ""
end

def get_login
  prompt = TTY::Prompt.new

  $name = prompt.ask("Please enter full name to login:")

  until $name != nil && $name.split.count >= 2 && $name.match(" ") != nil && $name[/[a-zA-Z]+/] == $name.split[0]
    $name = prompt.ask("Please enter a valid full name:")
  end

  $name = $name.downcase


  heart = prompt.decorate('❤ ', :cyan)
  $password = prompt.mask("Please enter a password:", mask: heart)
  until $password != nil
    $password = prompt.mask("Please enter a valid password:", mask: heart)
  end

  users = User.where(name: $name)

  if users.empty?
    User.create(name: $name, password: $password)
  else
    password = User.find_by(name: $name).password
    until password == $password
      puts "Incorrect Password! Please try again!", ""
      $password = prompt.mask("Please enter a password:", mask: heart)
    end
    User.find_by(password: $password)
  end
end

def get_user
  User.find_by(name: $name, password: $password)
end

def add_new_coffee
  prompt = TTY::Prompt.new
  inputs = []
  puts ""
  menu_message
  user_id = get_user.id

  request = ["Please enter a coffee name", "Where did you get it?", "How did it taste?", "How much did it cost? (Enter Number)"]
  request.each do |request|
    puts ""
    input = prompt.ask(request)
    until input != nil
      input = prompt.ask("Please enter a valid input")
    end
    if input.include?('menu')
      welcome
      break
    end
    inputs << input
  end

  until inputs[0][/[a-zA-Z]+/] == inputs[0].split[0]
    inputs[0] = prompt.ask("Please enter a valid coffee name")
  end

  until inputs[1][/[a-zA-Z]+/] == inputs[1].split[0] || inputs[1][/[a-zA-Z]+'+[a-zA-Z]/] == inputs[1].split[0]
    inputs[1] = prompt.ask("Please enter a valid shop name")
  end

  if inputs.count == 4
    while inputs[3].to_f <= 0
      inputs[3] = prompt.ask("Please enter a valid number for cost")
    end
    Coffee.create(name: capitalize(inputs[0]), shop_name: capitalize(inputs[1]), taste: inputs[2], cost: inputs[3])
    MyCoffee.create(user_id: user_id, coffee_id: Coffee.last.id)
    puts "Thanks for letting me know!"
    sleep(3.seconds)
    welcome
  end
end

def see_all_coffees
  prompt = TTY::Prompt.new
  if get_user.coffee_names.empty?
    puts "\nNo coffees!"
  else
    puts "\nHere are your coffees:", ""
    get_user.coffees.each {|coffee| puts "\n Name: #{coffee.name}\n Shop: #{coffee.shop_name}\n Cost: #{coffee.cost}\n Taste: #{coffee.taste}", ""}
  end
  input = prompt.ask("Press enter to return to menu")
  until input == nil
    input = prompt.ask("Press enter to return to menu")
  end
  welcome
end

def add_to_favorites
  prompt = TTY::Prompt.new
  puts "", menu_message
  coffee_input = prompt.ask("Please enter the coffee's name")
  shop_input = prompt.ask("Please enter a shop name")

  until coffee_input != nil && shop_input != nil && coffee_input[/[a-zA-Z]+/] == coffee_input.split[0] && shop_input[/[a-zA-Z]+/] == shop_input.split[0] || [/[a-zA-Z]+'+[a-zA-Z]/] == shop_input.split[0]
    if coffee_input == nil || coffee_input[/[a-zA-Z]+/] != coffee_input.split[0]
    coffee_input = prompt.ask("Please enter a valid coffee name")
    elsif shop_input == nil || shop_input[/[a-zA-Z]+'+[a-zA-Z]/] == shop_input.split[0]
      shop_input = prompt.ask("Please enter a valid shop name")
    end

    if coffee_input.include?("menu") || shop_input.include?("menu")
      break
    end
  end

  if coffee_input.include?("menu") || shop_input.include?("menu")
    welcome
  elsif get_user.coffee_names.exclude?(capitalize(coffee_input))
    puts "No Coffee Found"
    sleep(3.seconds)
    welcome
  else
    get_user.coffees.each do |coffee|
      if coffee.name.downcase == coffee_input.downcase && coffee.shop_name.downcase == shop_input.downcase
        coffee.favorites = true
        coffee.save
        puts "Added to favorites!"
      end
    end
    sleep(3.second)
    welcome
  end
end

def bring_up_favorites
  prompt = TTY::Prompt.new

  favorites = get_user.coffees.select {|coffee_name| coffee_name.favorites == true}
  if favorites.empty?
    puts "\nYou have no favorites!", ""
  else
    favorites.each {|fave_coffee| puts "", "You love this coffee:", "", "\n Name: #{fave_coffee.name}\n Shop: #{fave_coffee.shop_name}\n Cost: #{fave_coffee.cost}\n Taste: #{fave_coffee.taste}", ""}
  end
  input = prompt.ask("Press enter to return to menu")
  until input == nil
    input = prompt.ask("Press enter to return to menu")
  end
  welcome
end

def suggestion
  prompt = TTY::Prompt.new
  menu_message
  cost = prompt.ask("How much do you want to pay? (Enter Number)")
  until cost != nil
    cost = prompt.ask("Please enter a valid number")
  end
  if cost.include?("menu")
    welcome
  else
    until cost.to_f > 0.0
      puts "Please enter a valid number for cost"
      suggestion
    end

    puts "Maybe try this:"
    suggestion = Coffee.new(name: Faker::Coffee.blend_name, shop_name: Faker::Hipster.word.capitalize + "'s", cost: rand(1..cost.to_f).round(2), taste: Faker::Coffee.notes)

    puts "\n Name: #{suggestion.name}\n Shop Name: #{suggestion.shop_name}\n Price: $#{suggestion.cost}\n Taste: #{suggestion.taste}", ""

    option = prompt.ask("Do you want to save this? (Y/N)").downcase

    until option == "y" || option == "n"
      option = prompt.ask("Please enter Y or N")
    end

    if option == "y"
      suggestion.save

      user_id = User.find_by(name: $name, password: $password).id

      MyCoffee.create(user_id: user_id, coffee_id: Coffee.last.id)
      puts "Saved"
    elsif option == "n"
      puts "It vanished!"
    end
    sleep(3.second)
    welcome
  end
end

def search_coffees
  prompt = TTY::Prompt.new
  inputs = []
  menu_message

  requests = ["What coffee would you like to search", "Which coffee shop?"]
  requests.each do |request|
    input = prompt.ask(request)
    until input != nil
      input = prompt.ask("Please enter a valid input")
    end
    if input.include?('menu')
        welcome
        break
    end
    inputs << input
  end

  until inputs[0][/[a-zA-Z]+/] == inputs[0].split[0]
    inputs[0] = prompt.ask("Please enter a valid coffee name")
  end

  until inputs[1][/[a-zA-Z]+/] == inputs[1].split[0] || inputs[1][/[a-zA-Z]+'+[a-zA-Z]/] == inputs[1].split[0]
    inputs[1] = prompt.ask("Please enter a valid shop name")
  end

  if inputs.count == 2
    found_coffee = Coffee.find_by(name: capitalize(inputs[0]), shop_name: capitalize(inputs[1]))

    if found_coffee == nil
      puts "Sorry, no coffee by that name!"
    else
      puts "\n Name: #{found_coffee.name}\n Shop Name: #{found_coffee.shop_name}\n Price: $#{found_coffee.cost}\n Taste: #{found_coffee.taste}", ""
    end
    menu_input = prompt.ask("Press enter to return to menu")
    until menu_input == nil
      menu_input = prompt.ask("Press enter to return to menu")
    end
    welcome
  end
end

def goodbye
  pid = fork{exec 'afplay', './media/music/words_fail.m4a'}
  Catpix::print_image "./media/images/goodbye_better.png",
  :limit_x => 0.75,
  :limit_y => 0.75,
  :center_x => true,
  :center_y => true,
  :resolution => "high"
  puts "Song - Words Fail by Brian Detlefs. Follow on Instagram @bdetlefsmusic"
  sleep(8.seconds)
  exit
end

def capitalize(name)
  if name.split(' ').size > 1
    name.split.map {|x| x.capitalize!}.join(' ')
  else
    name.capitalize!
  end
end

def menu_message
  puts "If you would like to return to menu, please enter 'menu'"
end


def easter_egg
  pid = fork{exec 'afplay', './media/music/hey_ya.m4a'}
  Catpix::print_image "./media/images/flatiron_school.png",
  :limit_x => 0.75,
  :limit_y => 0.75,
  :center_x => true,
  :center_y => true,
  :resolution => "high"
  puts "Song - Hey Ya! by Outkast"
  sleep(5.seconds)
  welcome
end
