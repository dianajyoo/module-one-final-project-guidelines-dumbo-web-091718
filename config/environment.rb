require 'bundler'
gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'

Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

ActiveRecord::Base.logger = nil
