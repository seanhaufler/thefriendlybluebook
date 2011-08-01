module ApplicationHelper
=begin
  @params: none
  @path: ALL

  The following returns an array of stylesheets that are loaded on all pages
=end
  def stylesheets
    stylesheet_link_tag ($STANDARD_STYLESHEETS + @stylesheets.to_a)
  end

=begin
  @params: none
  @path: ALL

  The following returns an array of js files that are loaded on all pages
=end
  def javascripts
    javascript_include_tag ($STANDARD_JAVASCRIPTS + @javascripts.to_a)
  end

=begin
  @params: none
  @path: ALL

  The following constructs a custom title for each page
=end
  def title
    "The Friendly Bluebook" + (@title ? " | " : "") + @title.to_s
  end

=begin
  @params: none
  @path: ALL

  Check if the user has a facebook token and if they do return it
=end
  def get_facebook_cookie
    # Check to see if we even have the cookie
    if not cookies["fbs_"  + $FB_APP_ID]
      nil
      return
    end

    # First we make an array for all of the cookie args
    arguments = Hash.new

    # Convert the token into a hash map
    token = cookies["fbs_"  + $FB_APP_ID][1..
      (cookies["fbs_"  + $FB_APP_ID].length - 2)]
    token = token.split("&")
    token.map{|item| 
      tokens = item.split("=")
      arguments[tokens[0]] = tokens[1]
    }

    # Go through the sorted hash and add to the payload
    payload = ""
    arguments.sort.each do |kvpair|
      if kvpair.first != "sig"
        payload = payload + kvpair.first + "=" + kvpair.last
      end

      # Do the extra work of queuing the user creation if the user doesn't exist
      if kvpair.first == "uid"
        User.find_or_create_by_facebook_id(kvpair.last.to_i)
      end

      if kvpair.first == "access_token"
        @access_token = kvpair.last
      end
    end

    # Check the validation to make sure it's a valid key
    if Digest::MD5.hexdigest(payload + $FB_APP_SECRET) != arguments["sig"]
        nil

    # Valid signature!
    else
        arguments
    end
  end

=begin
  @params: Object

  Take an object and make a JSON string of it
=end
  def to_JSON(object)
    json = "{ "
    object.attributes.each do |key, val|
      json = json + "'#{key}': '#{val}', "
    end
    json = json + " }"
  end
  
#access_token=102218646546092%7C2.AQC3cg_y4l0AptXw.3600.1312167600.1-829745507%7CYUBtcBqcx4J7eMY40N-zTxkFm5w
#    'https://graph.facebook.com/me?access_token=' .
#    $cookie['access_token']));

end
