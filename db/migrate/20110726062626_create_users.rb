class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :facebook_id
      t.string :email
      t.string :name
      t.string :taking
      t.string :shopping
      t.string :avoiding

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
