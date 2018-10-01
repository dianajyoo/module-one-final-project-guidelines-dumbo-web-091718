require_relative '../config/environment'
require 'pry'


puts "HELLO WORLD"

puts "What is your full name? "
name = gets.chomp
User.find_or_create_by(name)

puts "Hi, #{user_name.name}"

binding.pry
0
