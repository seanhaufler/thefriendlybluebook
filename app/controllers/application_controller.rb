class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery

  # Facebook App Secrets
  $FB_APP_ID = "102218646546092"
  $FB_APP_SECRET = ""

  # Design considerations
  $STANDARD_STYLESHEETS = ["bluebook/classes", "bluebook/colors", 
    "bluebook/elements", "bluebook/typography", "gs/gs", "gs/reset", "gs/text",
    "jquery/ui"]
  $STANDARD_JAVASCRIPTS = ["jquery/jquery.min", "jquery/jquery-ui.min",
    "application", "rails"]
end
