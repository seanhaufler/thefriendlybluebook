class UsersController < ApplicationController

  before_filter :get_user

=begin
  @params: bucket, course
  @path: /add
  @before_filter: get_user
  @method: POST

  The following adds a course to the user's bucket
=end
  def add
    render :nothing => true and return
  end

=begin
  @params: uid, name, email
  @path: /update
  @before_filter: get_user
  @method: POST

  The following updates a user's information in the db
=end
  def remove
    render :nothing => true and return
  end

=begin
  @params: uid, name, email
  @path: /update
  @before_filter: get_user
  @method: POST

  The following updates a user's information in the db
=end
  def update
    @user.update_attributes({:name => params[:name], :email => params[:email]})

    render :nothing => true and return
  end

end
