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
      if kvpair.first == "uid" and not User.find_by_facebook_id(kvpair.last)
          User.create(:facebook_id => kvpair.last)
          @firstTime = true
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
      json = json + "'#{key}': '#{val.to_s.gsub("'", "\\\\'")}', "
    end
    json = json + " }"
  end

end
