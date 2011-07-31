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
  
end
