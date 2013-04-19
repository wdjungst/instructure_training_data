require 'rubygems'
require 'yaml'
require 'google_drive'
require 'pry'

CONFIG = YAML::load_file(File.expand_path(File.dirname(__FILE__) + '/config/config.yml'))

#FORM INFO
#get all submissions spreadsheet ids for each week
#itterate through spreadsheets and mine data

class User
  attr_accessor :name, :posts
	
  def initialize(name)
    @name = name
  end
end

@spreadsheet_ids = []

@feedback = CONFIG['feedback']
@feedback_keys = {:week1 => CONFIG['week1'], :week2 => CONFIG['week2'], :week3 => CONFIG['week3'], :week4 => CONFIG['week4'],
	:week5 => CONFIG['week5'], :week6 => CONFIG['week6'], :week7 => CONFIG['week7'], :week8 => CONFIG['week8'] }

@session = GoogleDrive.login(CONFIG['user'], CONFIG['pass'])

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
  @spreadsheet_ids.each_with_index do |week, i|
    i += 1
    week.each do |id|
      spreadsheet = @session.spreadsheet_by_key(id)
      ws = spreadsheet.worksheets[0]
      puts spreadsheet.title
      puts "Timestamp: #{ws[2,1]}"
      puts "How helpful is this outline: #{ws[2,2]}"
      puts "How could we improve this training outline?: #{ws[2,3]}"
      puts "Cat Participant: #{ws[2,4]}"
      puts "##########################################################"
    end
  end
end
forms_spreadsheets_ids
binding.pry

