require 'rubygems'
require 'yaml'
require 'google_drive'
require 'pry'
require File.expand_path(File.dirname(__FILE__) + '/config/database')
require 'active_resource'

CONFIG = YAML::load_file(File.expand_path(File.dirname(__FILE__) + '/config/config.yml'))

class User
  attr_accessor :name, :week1, :week2, :week3, :week4, :week5, :week6, :week7, :week8, :posts
	
  def initialize(name, week1 = 0, week2 = 0, week3 = 0, week4 = 0, week5 = 0, week6 = 0, week7 = 0, week8 = 0, posts = 0)
    @name = name
    @posts = posts
    @week1 = week1
    @week2 = week2
    @week3 = week3
    @week4 = week4
    @week5 = week5
    @week6 = week6
    @week7 = week7
    @week8 = week8
  end
end

@spreadsheet_ids = []

@feedback = CONFIG['feedback']
@feedback_keys = {:week1 => CONFIG['week1'], :week2 => CONFIG['week2'], :week3 => CONFIG['week3'], :week4 => CONFIG['week4'],
	:week5 => CONFIG['week5'], :week6 => CONFIG['week6'], :week7 => CONFIG['week7'], :week8 => CONFIG['week8'] }

@session = GoogleDrive.login(CONFIG['user'], CONFIG['pass'])

class Participants < ActiveRecord::Base
end

def users
  current_users = []
  sheet = @session.spreadsheet_by_key(CONFIG['users'])
  ws = sheet.worksheets[0]
  ws.num_rows.times do |user|
    current_users << ws[user + 1,1]
  end
  participants = Participants.find(:all)
  current_users.each do |u|
    exists = false
    participants.each do |p|
      if u == p.name
        exits = true
      end
    end
    Participant.create!(:name => u, :week1 => 0, :week2 => 0, :week3 => 0, :week4 => 0, :week5 => 0, :week6 => 0, :week7 => 0, :week8 => 0) 
  end
end

def forms_spreadsheets_ids(feedback_keys = @feedback_keys)
  feedback_keys.each_value do |week|
    ids = []
    collection = @session.collection_by_url "#{@feedback}#{week}"
    spreadsheets = collection.spreadsheets
    spreadsheets.each { |sheet| ids << sheet.resource_id.split(":").last }
    @spreadsheet_ids << ids
  end
end

def gather_data
  weeks = {:week1 => "week1", :week2 => "week2", :week3 => "week3", :week4 => "week4", :week5 => "week5", :week6 => "week6", :week7 => "week7", :week8 => "week8" }
  @spreadsheet_ids.each_with_index do |week, i|
    week_num = weeks.key("week#{i + 1}")
    week.each do |id|
      spreadsheet = @session.spreadsheet_by_key(id)
      ws = spreadsheet.worksheets[0]
      ws.num_rows.times do |row|
        row += 1
        person = Participant.where(:name => ws[row,4].strip)
        if person.count != 0
          person = person.first
          person.increment!(week_num) 
        end
      end
    end
  end
end
users
binding.pry
forms_spreadsheets_ids
gather_data
