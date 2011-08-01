class UsersController < ApplicationController

  include UsersHelper
  before_filter :get_user

=begin
  @params: type, course
  @path: /add
  @before_filter: get_user
  @method: POST

  The following adds a course to the user's bucket
=end
  def add
    # Provide a switch based on which bucket specified
    case params[:type].downcase
      when "taking"
        @user.taking << params[:course].to_i

      when "shopping"
        @user.shopping << params[:course].to_i

      when "avoiding"
        @user.avoiding << params[:course].to_i
    end

    @user.save
    render :nothing => true and return
  end

=begin
  @params: type, course
  @path: /add
  @before_filter: get_user
  @method: POST

  The following removes a course from the user's bucket
=end
  def remove
    # Provide a switch based on which bucket specified
    case params[:type].downcase
      when "taking"
        @user.taking.delete(params[:course].to_i)

      when "shopping"
        @user.shopping.delete(params[:course].to_i)

      when "avoiding"
        @user.avoiding.delete(params[:course].to_i)
    end

    @user.save
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
