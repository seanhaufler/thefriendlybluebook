class SearchController < ApplicationController
  include SearchHelper
  before_filter :check_cookie, :only => [:index]

=begin
  @params: none
  @path: /search
  @method: GET/POST
  @before_filter: none

  The following renders the homepage for our application
=end
  def index
    # Create empty hash maps for when the user queries
    @takingMap = Hash.new
    @shoppingMap = Hash.new
    @avoidingMap = Hash.new

    # If someone has submitted something then search
    if params[:query]
      search

    # Otherwise don't do anything
    else
      @results = Array.new
      @friends = Array.new
      User.all.map { |user| 
        taking = user.taking.map{|course| Course.find(course)}
        shopping = user.shopping.map{|course| Course.find(course)}
        avoiding = user.avoiding.map{|course| Course.find(course)}

        @friends << {:user => user, 
            :empty => (user.taking.empty? and user.shopping.empty? and 
              user.avoiding.empty?), 
            :taking => taking, :shopping => shopping, :avoiding => avoiding, 
            :taking_full => taking, :shopping_full => shopping, 
            :avoiding_full => avoiding }
      }
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
      "library/ycps", "jquery/autoresize", "jquery/strftime"]
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

    # Check for gut, new, or cancelled
    if params[:gut] == "yes"
      query = query + " AND gut = true "
    end
    if params[:new] == "yes"
      query = query + " AND courses.new = true "
    end
    if params[:cancelled] == "yes"
      query = query + " AND cancelled = true "
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

    ##### Initialize a DB Parameter #####
    dbParameters = Hash.new

    # Take the department parameter
    if params[:subject] and params[:subject] != "Enter Subject of Study..." and
       params[:subject] != "All Subjects of Instruction"
      query = query + " AND (department ILIKE :dept OR 
        department_abbr = :dept_abbr) "
      dbParameters[:dept] = params[:subject].to_s
      dbParameters[:dept_abbr] = params[:subject].to_s.upcase
    end

    # Take the course number
    if params[:course] and params[:course] != "Enter Course Number..."
      query = query + "AND (department_abbr || ' ' || number) ILIKE :course "
      dbParameters[:course] = "%#{params[:course]}%"
    end

    # Take the instructor parameter
    if params[:instructor] and params[:instructor] != "Enter Instructor Name..."
      query = query + "AND (professor ILIKE :prof_1 OR professor ILIKE :prof_2)"
      dbParameters[:prof_1] = "% #{params[:instructor]}%"
      dbParameters[:prof_2] = "#{params[:instructor]}%"
    end

    ##### Execute the main DB query #####
    results.concat(Course.where(query, 
      dbParameters).order("department, number, section"))
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
      # Incorporate the top-level query into names and emails
      added = false
      queries = params[:query].split(" ").map{|q| q.to_s.downcase}
      queries.each do |q|
        if u.name.to_s.index(q) or u.email.to_s.index(q)
          # Map out each course the user is taking, shopping, and avoiding
          taking = u.taking.map{ |course| Course.find(course) }
          shopping = u.shopping.map{ |course| Course.find(course) }
          avoiding = u.avoiding.map{ |course| Course.find(course) }

          # Add the friend and all their classes to the friends array
          friends.push({:user => u, 
            :empty => (u.taking.empty? and u.shopping.empty? and 
              u.avoiding.empty?), 
            :taking => taking, :shopping => shopping, :avoiding => avoiding, 
            :taking_full => taking, :shopping_full => shopping, 
            :avoiding_full => avoiding })
          added = true
          
          break
        end
      end

      if not added
          # See if the user is taking, shopping, or avoiding any of the results
          taking = (u.taking & result_ids).map{|course| 
            Course.find(course)}
          shopping = (u.shopping & result_ids).map{|course| 
            Course.find(course)}
          avoiding = (u.avoiding & result_ids).map{|course| 
            Course.find(course)}

          # We add the user in if there was an overlap
          if not (taking.empty? and shopping.empty? and avoiding.empty?)
            friends.push({:user => u, :status => 0, :taking => taking, 
              :shopping => shopping, :avoiding => avoiding,
              :taking_full => u.taking.map{ |course| Course.find(course) }, 
              :shopping_full => u.shopping.map{ |course| Course.find(course) }, 
              :avoiding_full => u.avoiding.map{ |course| Course.find(course) }})
            added = true
          end
      end

      # If we added the person to the list then there was an intersection so we
      #   add this person to the places in the hash map they belong for the 
      #   flyout
      if added
        # Hash map for taking
        u.taking.each do |course|
            @takingMap[course.to_i] ||= Array.new
            @takingMap[course.to_i].push(u)
        end

        # Hash map for shopping
        u.shopping.each do |course|
            @shoppingMap[course.to_i] ||= Array.new
            @shoppingMap[course.to_i].push(u)
        end

        # Hash map for avoiding
        u.avoiding.each do |course|
            @avoidingMap[course.to_i] ||= Array.new
            @avoidingMap[course.to_i].push(u)
        end
      end
    end
    @friends = friends
  end
end
