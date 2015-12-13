require 'yaml'
require 'json'
require 'pg'
require 'active_record'
Dir[File.dirname('./') + '/app/models/*'].each {|file| require file }
Dir[File.dirname('./') + '/app/helpers/*'].each {|file| require file }

ActiveRecord::Base.establish_connection YAML.load_file('config/database.yml')