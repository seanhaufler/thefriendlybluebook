# == Schema Information
# Schema version: 20110726063157
#
# Table name: courses
#
#  id                      :integer         not null, primary key
#  department              :string(255)
#  department_abbr         :string(255)
#  oci_id                  :integer
#  number                  :integer
#  section                 :integer
#  title                   :string(255)
#  professor               :string(255)
#  description             :text
#  prerequisites           :string(255)
#  time_one_start          :datetime
#  time_one_end            :datetime
#  time_two_start          :datetime
#  time_two_end            :datetime
#  time_three_start        :datetime
#  time_three_end          :datetime
#  final_exam_time         :datetime
#  semester                :string(255)
#  starred                 :boolean
#  L1                      :boolean
#  L2                      :boolean
#  L3                      :boolean
#  L4                      :boolean
#  L5                      :boolean
#  QR                      :boolean
#  WR                      :boolean
#  Hu                      :boolean
#  Sc                      :boolean
#  So                      :boolean
#  readings_in_translation :boolean
#  category                :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#

class Course < ActiveRecord::Base

  serialize :comments

=begin
  @params: none

  Returns a display string for the course's time
=end
  def time_string
    # Iterate through each possible time variable
    numbers = ["one", "two", "three", "four", "five"]

    days = Array.new
    start_times = Array.new
    end_times = Array.new
    time_output = ""

    numbers.each do |num|
      # Check to see if the time even exists
      if self["time_#{num}_start"]
        beginning = self["time_#{num}_start"].split(" ")
        ending = self["time_#{num}_end"].split(" ")

        # Insert the day and time based on whether they exist
        if start_times.index(beginning[1]) and end_times.index(ending[1])
          loc = start_times.index(beginning[1])
          days[loc] = "#{days[loc]}#{beginning[0]}"

        # The day and time haven't been seen yet, create new triplet
        else
          days << beginning[0]
          start_times << beginning[1]
          end_times << ending[1]
        end
      end
    end

    # Finally, construct the time string to return
    days.each_index do |i|
      time_output = "#{time_output} #{days[i]} #{start_times[i]}
        - #{end_times[i]}, "
    end
    time_output
  end
  
end
