require 'rubygems'
require 'yaml'
require 'google_drive'
require 'optparse'
require 'active_resource'
require File.expand_path(File.dirname(__FILE__) + '/config/database')
require File.expand_path(File.dirname(__FILE__) + '/app/models/training_data')
require File.expand_path(File.dirname(__FILE__) + '/app/models/staging_training_data')

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

@copy_data = true

def connection_failed(object)
  if object == ''
    @copy_data = false
  else
    @copy_data = true
  end
end

def copy_tables
  StagingTrainingData.destroy_all
  records = TrainingData.find(:all)
  records.each do |r|
    StagingTrainingData.create!(:name => r.name, :week1 => r.week1, :week2 => r.week2, :week3 => r.week3, :week4 => r.week4, :week5 => r.week5, :week6 => r.week6, :week7 => r.week7, :week8 => r.week8) 
  end
end

def empty_main_table
  TrainingData.destroy_all
end

def users
  ws = ''
  current_users = []
  sheet = @session.spreadsheet_by_key(CONFIG['users'])
  ws = sheet.worksheets[0]
  connection_failed(ws)
  ws.num_rows.times do |user|
    current_users << ws[user + 1,1]
  end
  participants = TrainingData.find(:all)
  current_users.each do |u|
    exists = false
    participants.each do |p|
      if u == p.name
        exists = true
      end
    end
    TrainingData.create!(:name => u, :week1 => 0, :week2 => 0, :week3 => 0, :week4 => 0, :week5 => 0, :week6 => 0, :week7 => 0, :week8 => 0) 
  end
end

def forms_spreadsheets_ids(feedback_keys = @feedback_keys)
  collection = ''
  feedback_keys.each_value do |week|
    ids = []
    collection = @session.collection_by_url "#{@feedback}#{week}"
    connection_failed(collection)
    spreadsheets = collection.spreadsheets
    spreadsheets.each { |sheet| ids << sheet.resource_id.split(":").last }
    @spreadsheet_ids << ids
  end
end

def gather_data
  ws = ''
  weeks = {:week1 => "week1", :week2 => "week2", :week3 => "week3", :week4 => "week4", :week5 => "week5", :week6 => "week6", :week7 => "week7", :week8 => "week8" }
  @spreadsheet_ids.each_with_index do |week, i|
    week_num = weeks.key("week#{i + 1}")
    week.each do |id|
      spreadsheet = @session.spreadsheet_by_key(id)
      ws = spreadsheet.worksheets[0]
      connection_failed(ws)
      ws.num_rows.times do |row|
        row += 1
        person = TrainingData.where(:name => ws[row,4].strip)
        if person.count != 0
          person = person.first
          person.increment!(week_num) 
        end
      end
    end
  end
end


def options
  options = {}
  optparse = OptionParser.new do |opts|
    options[:run] = false
    
    opts.on('-r', '--run', 'Run program') do
      options[:run] = true
    end
    opts.on('-n', 'new', 'Update spreadsheets with new data') do
      options[:new] = true
    end
    opts.on('-h', '--help', 'Display this screen') do
      puts opts
      exit
    end
  end

  optparse.parse!

  if options[:run]
   empty_main_table
    users
    forms_spreadsheets_ids
    gather_data
    copy_tables if @copy_data == true
  end
  if options[:new]
    update_spreadsheet_data
  end
end

options
