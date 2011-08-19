class RemoveColFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :facebook_id
    add_column :users, facebook_id, :string
  end

  def self.down
    remove_column :users, :facebook_id
    add_column :users, :facebook_id, :integer
  end
end
