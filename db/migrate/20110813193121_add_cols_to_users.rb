class AddColsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :ical, :text
  end

  def self.down
    remove_column :users, :ical
  end
end
