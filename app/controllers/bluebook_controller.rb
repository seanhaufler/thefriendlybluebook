class BluebookController < ApplicationController
  include BluebookHelper
  before_filter :check_cookie, :only => [:index]

=begin
  @params: none
  @path: /
  @before_filter: none
  @method: GET

  The following renders the homepage for our application
=end
  def index
    @stylesheets = ["pages/index"]
    @javascripts = ["pages/index"]
  end

=begin
  @params: uid, name, email
  @path: /update
  @before_filter: none
  @method: POST

  The following updates a user's information in the db
=end
  def update
    user = User.find_or_create_by_facebook_id(params[:uid].to_i)
    user.update_attributes({:name => params[:name], :email => params[:email]})

    render :nothing => true and return
  end

end
