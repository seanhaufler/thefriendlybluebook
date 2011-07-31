class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :department
      t.string :department_abbr
      t.integer :oci_id
      t.string :number
      t.string :section
      t.string :title
      t.string :professor
      t.text :description
      t.text :prerequisites
      t.string :time_one_start
      t.string :time_one_end
      t.string :time_two_start
      t.string :time_two_end
      t.string :time_three_start
      t.string :time_three_end
      t.string :time_four_start
      t.string :time_four_end
      t.string :time_five_start
      t.string :time_five_end
      t.string :final_exam_time
      t.string :semester
      t.boolean :starred
      t.boolean :L1
      t.boolean :L2
      t.boolean :L3
      t.boolean :L4
      t.boolean :L5
      t.boolean :QR
      t.boolean :WR
      t.boolean :Hu
      t.boolean :Sc
      t.boolean :So
      t.boolean :readings_in_translation
      t.boolean :reading_period
      t.string :category
      t.boolean :cancelled
      t.boolean :gut
      t.text :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
