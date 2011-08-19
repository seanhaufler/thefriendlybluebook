class CoursesController < ApplicationController

  before_filter :get_user

=begin
  @params: course, content
  @path: /comment
  @before_filter: get_user
  @method: POST

  The following adds a comment to the specified course
=end
  def comment
    # Get the course, push a new comment, and save the course
    course = Course.find(params[:course])
    course.comments.insert(0, [@user.facebook_id, @user.name, params[:content],
      Time.now])
    course.save

    # No rendering
    render :nothing => true and return
  end

end
