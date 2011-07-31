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

end
