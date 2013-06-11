require 'rubygems'
require 'active_record'
require "#{settings.root}/app/models/training_data" 
require "#{settings.root}/app/models/staging_training_data" 

class Drago < Sinatra::Application
  @@table = TrainingData

  def select_table
    if TrainingData.find(:all).count == 0
      @@table = StagingTrainingData
    else
      @@table = TrainingData
    end
  end

  def total_all_weeks(user)
    user.week1 + user.week2 + user.week3 + user.week4 + user.week5 + user.week6 + user.week7 + user.week8
  end

  def total_posts
    users = []
    people = @@table.find(:all)
    people.each do |person|
      users << "#{total_all_weeks(person)},#{person.name}~"
    end
    users
  end

  def weekly_posts(number)
    users = []
    people = @@table.find(:all)
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
    select_table
    haml :index
  end

  get '/all_posts' do
    total_posts
  end

  get '/week/:number' do |number|
    weekly_posts(number)    
  end

  get '/user_info/:name' do |name|
    user = @@table.where(:name => name).first
    "#{user.week1}, #{user.week2}, #{user.week3}, #{user.week4}, #{user.week5}, #{user.week6}, #{user.week7}, #{user.week8}"
  end
end
