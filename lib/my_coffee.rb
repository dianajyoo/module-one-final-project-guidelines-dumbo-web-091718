class My_Coffee < ActiveRecord::Base
  belongs_to :user
  belongs_to :coffee
end
