class SearchController < ApplicationController
  include SearchHelper
  #before_filter :check_cookie, :only => [:index]

=begin
  @params: none
  @path: /search
  @method: GET/POST
  @before_filter: none

  The following renders the homepage for our application
=end
  def index
    # If someone has submitted something then search
    if params[:query]
      search

    # Otherwise don't do anything
    else
      @results = []
      @friends = []
    end

    # Get the user from the cookie and the classes count
    get_user

    # Get each of the user's buckets
    @taking = @user.taking.map{|course| Course.find(course)}
    @shopping = @user.shopping.map{|course| Course.find(course)}
    @avoiding = @user.avoiding.map{|course| Course.find(course)}
    
    # Preload a count on each of the user's buckets
    @takingCount = @user.taking.length
    @shoppingCount = @user.shopping.length
    @avoidingCount = @user.avoiding.length

    # Standard rendering work
    @title = "Find Courses"
    @stylesheets = ["pages/search"]
    @javascripts = ["pages/search", "library/facebook", "library/user",
      "library/ycps"]
  end

=begin
  @params: none
  @path: /search?query
  @method: POST
  @before_filter

  The following is a separate method for querying the db
=end
  def search
    query = "semester = 'Fall 2011'"
    results = Array.new

    # Take the department parameter
    if params[:subject] != "Enter Subject of Study..."
      query = query + " AND (department = ? OR department_abbr = ?) "
    end

    # Check which category was selected
    if params[:group] == "U"
      query = query + " AND category = 'Undergraduate' "
    elsif params[:group] == "G"
      query = query + " AND category = 'Graduate' "
    elsif params[:group] == "P"
      query = query + " AND category = 'Professional' "
    end

    # Do something for each day of the week
    days = Array.new
    weekdays = {"1" => "M", "2" => "T", "3" => "W", "4" => "Th", "5" => "F"}
    numbers = ["one", "two", "three", "four", "five"]
    if params[:dow]
      params[:dow].each do |day|
        if weekdays[day]
          # Run a check on the time parameters
          beginning = params[:from].to_i
          ending = params[:to].to_i
          if beginning != 0 and ending != 0
            # First check if the end is greater than the beginning
            if ending <= beginning
              @results = [] and return

            # Otherwise we're good
            else
              # Make a wierd string because we boxed ourselves in with strings
              numbers.each do |number|
                days << "time_#{number}_end = '#{weekdays[day]} #{beginning}.00'"
                for i in ((beginning + 1)..(ending - 1))
                  days << "time_#{number}_start ILIKE '#{weekdays[day]} #{i}.%%'"
                  days << "time_#{number}_end ILIKE '#{weekdays[day]} #{i}.%%'"
                end
                days << "time_#{number}_start = '#{weekdays[day]} #{ending}.00'"
              end
            end
          end
        end
      end
    end

    # If a day was checked add it to the query
    if not days.empty?
      query = query + " AND (" + days.join(" OR ") + ")"
    end

    # Check the language, skill,area parameters
    checks = Array.new
    if params[:L1] == "L1"
      checks << "\"L1\""
    end
    if params[:L2] == "L2"
      checks << "\"L2\""
    end
    if params[:L3] == "L3"
      checks << "\"L3\""
    end
    if params[:L4] == "L4"
      checks << "\"L4\""
    end
    if params[:L5] == "L5"
      checks << "\"L5\""
    end
    if params[:QR] == "QR"
      checks << "\"QR\""
    end
    if params[:WR] == "WR"
      checks << "\"WR\""
    end
    if params[:Sc] == "Sc"
      checks << "\"Sc\""
    end
    if params[:Hu] == "Hu"
      checks << "\"Hu\""
    end
    if params[:So] == "So"
      checks << "\"So\""
    end

    # If there was anything selected add it
    if not checks.empty?
      query = query + " AND (" + checks.join(" OR ") + ")"
    end

    # Check for final exam, reading_period and readings_in_translation
    if params[:no_final] == "yes"
      query = query + " AND final_exam_time IS NULL "
    end
    if params[:readings_in_translation] == "yes"
      query = query + " AND readings_in_translation "
    end
    if params[:reading_period] == "yes"
      query = query + " AND reading_period "
    end
    if params[:not_reading_period] == "yes"
      query = query + " AND reading_period IS NULL "
    end

    # Next, if the user searched with course number or instructor
    if params[:course] != "Enter Course Number..." or 
       params[:instructor] != "Enter Instructor Name..."
      query = query + "AND ((department_abbr || ' ' || number) ILIKE ? OR "
      query = query + "professor ILIKE ? OR "
      query = query + "professor ILIKE ?)"
      
      # Execute the main DB query
      results.concat(Course.where(query, params[:subject], 
        params[:subject], "#{params[:course]}%", "% #{params[:instructor]}%", 
        "#{params[:instructor]}% %").order("department, number, section"))

    # No course number or instructor, search as such
    else
      # Execute the main DB query
      results.concat(Course.where(query, params[:subject], 
        params[:subject]).order("department, number, section"))
    end

    @results = results.uniq
    
    # Finally, parse down the top level query
    if params[:query] != "Enter Search Query..."
      filtered_results = Array.new
      
      # Incorporate this through a find_all
      queries = params[:query].split(" ").map{|q| q.to_s.downcase}
      queries.each do |q|
        filtered_results.concat(results.find_all{ |result|
          result.department.to_s.downcase.index(q) or
          result.department_abbr.to_s.downcase.index(q) or
          result.title.to_s.downcase.index(q) or
          result.professor.to_s.downcase.index(q) or
          result.description.to_s.downcase.index(q) or
          result.prerequisites.to_s.downcase.index(q)
        })
      end

      @results = filtered_results.uniq
    end
    
    # Search through the user db for friends' emails and names
    friends = Array.new
    result_ids = @results.map{|r| r.id}
    User.all.each do |u|
      # See if the user is taking, shopping, or avoiding any of the results
      taking = (u.taking & result_ids)
      shopping = (u.shopping & result_ids)
      avoiding = (u.avoiding & result_ids)

      # We add the user in if there was an overlap
      if not (taking.empty? and shopping.empty? and avoiding.empty?)
        friends.push({:user => u, :taking => taking, :shopping => shopping,
          :avoiding => avoiding})

      # Incorporate the top-level query into names and emails
      else
        queries = params[:query].split(" ").map{|q| q.to_s.downcase}
        queries.each do |q|
          if u.name.index(q) or u.email.index(q)
            friends.push({:user => u, :status => -1})
            break
          end
        end
      end
      
    end
    @friends = friends
  end
end
