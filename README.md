# myBrews CLI

created by [Diana Yoo](https://github.com/dianajyoo) and [Brian DiRito](https://github.com/bcdirito)

myBrews uses Ruby and ActiveRecord to manage and interact with multiple databases.

myBrews is a Coffee Companion app, where users create a profile to save, favorite,
search, and get suggestions for coffee.

## ADDITIONAL GEMS
  1. faker
      - Generates fake data at random

  2. tty-prompt
      - An interactive command line prompt for getting and validating inputs
      - Allows for the implementation of menus

  3. pastel
      - Changes text colors

  4. catpix
      - Allows for the implementation of images

## Setup Instructions

Run a bundle install
 ``` 
 $ bundle install
 ```

If you receive an error during installation due to "rmagick", follow these instructions:
  ```
  1. brew uninstall imagemagick
  2. brew install imagemagick@6 && brew link imagemagick@6 --force
  3. gem install rmagick
  4. gem install catpix
  5. bundle install
  ```
  

## How it Works:
  1. Upon running, user will be asked to enter your full name and a password.
      - If you haven't created a profile yet, it will create one for you.
      - If you have a profile but entered a wrong password, you will be asked to re-enter your password.

  2. Once you reach the menu, find a choice using the arrow and enter keys. Follow the prompts you are asked.
      - If at any point you wish to return to the main menu, enter "menu"

  3. When you are finished, select "Quit" from the menu.


**Enjoy!**

## Sources

[Implementing Images](https://radek.io/2015/06/29/catpix/)

## Project Instructions:
**Command Line CRUD App**
  1. Access a Sqlite3 Database using ActiveRecord.
  2. You should have a minimum of three models.
  3. You should build out a CLI to give your user full CRUD ability for at least one of your resources. For example, build out a command line To-Do list. A user should be able to create a new to-do, see all todos, update a todo item, and delete a todo. Todos can be grouped into categories, so that a to-do has many categories and categories have many to-dos.
  4. Use good OO design patterns. You should have separate models for your runner and CLI interface.


















  ~FIND THE EASTER EGG~
