class User < ActiveRecord::Base

  def self.find_or_create_by(name)
    if User.count == 0 || self.find_by_name(name) == nil
      self.create(name: name)
    else
      self.all.find do |user|
        user.name == name
      end
    end
    "Hi, #{name}!"
  end

end
