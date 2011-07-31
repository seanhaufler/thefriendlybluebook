# == Schema Information
# Schema version: 20110726063157
#
# Table name: users
#
#  id         :integer         not null, primary key
#  email      :string(255)
#  name       :string(255)
#  taking     :string(255)
#  shopping   :string(255)
#  avoiding   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base

  serialize :taking
  serialize :shopping
  serialize :avoiding

=begin
    PRIVATE METHOD SECTION
=end
  private
  
    after_create :set_defaults
    def set_defaults
      # Initialize empty arrays
      self.taking = []
      self.shopping = []
      self.avoiding = []

      # Save the updated user
      self.save
    end

end
