require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'mysql',
  :host => 'localhost',
  :encoding => 'utf8',
  :database => 'training',
  :username => 'root',
  :password => 'password'
)

class Participant < ActiveRecord::Base
  attr_accessible :name, :week1, :week2, :week3, :week4, :week5, :week6, :week7, :week8
  ActiveRecord::Migration.class_eval do
    drop_table :participants if table_exists? 'participants'
    create_table :participants do |t|
      t.string :name
      t.string :responses
      t.integer :week1
      t.integer :week2
      t.integer :week3
      t.integer :week4
      t.integer :week5
      t.integer :week6
      t.integer :week7
      t.integer :week8
    end
  end
end

