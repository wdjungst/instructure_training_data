class CreateTrainingData < ActiveRecord::Migration
  def up
    create_table :training_data do |t|
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
    
    create_table :staging_training_data do |t|
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

  def down
    drop_table :training_data
  end
end
