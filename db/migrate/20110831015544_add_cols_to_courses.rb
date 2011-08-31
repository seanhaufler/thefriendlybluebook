class AddColsToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :room, :string
  end

  def self.down
    remove_column :courses, :room
  end
end
