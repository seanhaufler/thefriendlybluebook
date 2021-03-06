class ApplicationController < ActionController::Base
  include ApplicationHelper
  include UsersHelper

  protect_from_forgery

  $DEBUG_MODE = false

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

  $POSSIBLE_TIMES = ["one", "two", "three", "four", "five"]
  $BUCKETS = ["taking", "shopping", "avoiding"]

  # Design considerations
  $STANDARD_STYLESHEETS = ["bluebook/classes", "bluebook/colors", 
    "bluebook/elements", "bluebook/typography", "gs/gs", "gs/reset", "gs/text",
    "jquery/ui"]
  $STANDARD_JAVASCRIPTS = ["jquery/jquery.min", "jquery/jquery-ui.min",
    "application"]

  # Error trapping
  $WEBSITE_CONTACT = "contact@thefriendlybluebook.com"
  unless Rails.application.config.consider_all_requests_local
      rescue_from Exception, 
        :with => :render_error
      rescue_from ActiveRecord::RecordNotFound, 
        :with => :render_not_found
      rescue_from ActionController::RoutingError, 
        :with => :render_not_found
      rescue_from ActionController::UnknownController, 
        :with => :render_not_found
      rescue_from ActionController::UnknownAction, 
        :with => :render_not_found
  end

  private
    def render_not_found(exception)
        logger.error exception.backtrace
        Emailer.deliver_exception_report(exception, request.fullpath, @user, params)
        render "status/404.html"
    end

    def render_error(exception)
        logger.error exception.backtrace
        Emailer.deliver_exception_report(exception, request.fullpath, @user, params)
        render "status/500.html"
    end
end
