module UsersHelper

=begin
  @params: none

  Get a user from the current facebook cookie
=end
  def get_user
    args = get_facebook_cookie

    # Valid user
    if args
      @user = User.find_by_facebook_id(args['uid'])

    # Invalid user
    else
      #redirect_to root_path and return
    end
  end

end