class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :facebook_id
      t.string :email
      t.string :name
      t.text :taking
      t.text :shopping
      t.text :avoiding
      t.text :taken

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
