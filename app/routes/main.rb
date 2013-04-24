require 'rubygems'
require 'pry'
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
end

class Training < Sinatra::Application
  def total_all_weeks(user)
    user.week1 + user.week2 + user.week3 + user.week4 + user.week5 + user.week6 + user.week7 + user.week8
  end

  def total_posts
    users = []
    people = Participant.find(:all)
    people.each do |person|
      users << "#{total_all_weeks(person)},#{person.name}~"
    end
    users
  end

  def weekly_posts(number)
    users = []
    people = Participant.find(:all)
    people.each do |person| 
      if number == '0'
        value = total_all_weeks(person)
      else
        value = person.send("week#{number}")
      end
      users << "#{value},#{person.name}~" 
    end
    users
  end

  get '/' do
    haml :index
  end

  get '/all_posts' do
    total_posts
  end

  get '/week/:number' do |number|
    weekly_posts(number)    
  end
end
