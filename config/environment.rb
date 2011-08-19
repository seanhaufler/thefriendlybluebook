# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Bluebook::Application.initialize!

# For sending emails
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_charset = "utf-8"

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'thefriendlybluebook.com',
    :user_name            => 'notifications@thefriendlybluebook.com',
    :password             => 'bookblue1214',
    :authentication       => 'plain',
    :enable_starttls_auto => true  }
