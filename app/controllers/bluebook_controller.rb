class BluebookController < ApplicationController
  include BluebookHelper
  before_filter :check_cookie, :only => [:index]

=begin
  @params: none
  @path: /
  @before_filter: none

  The following renders the homepage for our application
=end
  def index
    @stylesheets = ["pages/index"]
    @javascripts = ["pages/index"]
  end

end
