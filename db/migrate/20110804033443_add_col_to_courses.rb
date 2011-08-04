class AddColToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :new, :boolean
  end

  def self.down
    remove_column :courses, :new
  end
end
