class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_cookie

  def check_cookie
    # if we have a valid cookie
    redirect_to search_path and return
    # else
    redirect_to root_path and return
  end

  # Design considerations
  $STANDARD_STYLESHEETS = ["bluebook/classes", "bluebook/colors", 
    "bluebook/elements", "bluebook/typography", "gs/gs", "gs/reset", "gs/text",
    "jquery/ui"]
  $STANDARD_JAVASCRIPTS = ["jquery/jquery.min", "jquery/jquery-ui.min",
    "application", "rails"]
end
