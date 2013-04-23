require 'rubygems'
require 'json'

class User
  include Mongoid::Document
  store_in database: 'training'

  field :name, type: String
  field :week1, type: Integer
  field :week2, type: Integer
  field :week3, type: Integer
  field :week4, type: Integer
  field :week5, type: Integer
  field :week6, type: Integer
  field :week7, type: Integer
  field :week8, type: Integer
end

