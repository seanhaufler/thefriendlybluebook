module SearchHelper

=begin
  @params: none

  Make sure a user is logged in
=end
  def check_cookie
    if not get_facebook_cookie
      redirect_to root_path and return
    end
  end
  
end
