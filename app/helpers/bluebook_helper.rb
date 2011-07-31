module BluebookHelper

=begin
  @params: none

  Make sure a user is not logged in
=end
  def check_cookie
    if get_facebook_cookie
      redirect_to search_path and return
    end
  end
  
end
