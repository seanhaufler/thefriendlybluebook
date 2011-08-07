class ApplicationController < ActionController::Base
  include ApplicationHelper
  include UsersHelper

  protect_from_forgery

  # Facebook App Secrets
  $FB_APP_ID = "102218646546092"
  $FB_APP_SECRET = "658fe4d28d7334f87f1434e1cc939e86"

  # Global config variables
  $TAKING = 0
  $SHOPPING = 1
  $AVOIDING = 2

  $COMMENT_FB_ID = 0
  $COMMENT_USER = 1
  $COMMENT_CONTENT = 2
  $COMMENT_DATE = 3

  # Design considerations
  $STANDARD_STYLESHEETS = ["bluebook/classes", "bluebook/colors", 
    "bluebook/elements", "bluebook/typography", "gs/gs", "gs/reset", "gs/text",
    "jquery/ui"]
  $STANDARD_JAVASCRIPTS = ["jquery/jquery.min", "jquery/jquery-ui.min",
    "application", "rails"]
end
