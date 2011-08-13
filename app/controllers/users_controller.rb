class UsersController < ApplicationController

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
  @path: /remove
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

=begin
  @params: none
  @path: /calendar
  @before_filter: get_user
  @method: GET

  The following takes a user's schedule and creates an iCal feed for it
=end
  def ical
    # First, we create a couple of variables for the ical time format and class
    #   start date
    ical_time_format = "%Y%m%dT%H%M%S"      
    classes_start = Time.utc(2011, 8, 31, 0, 0, 0)
  
    # Next, we dynamically generate the ICS file (standard header)
    File.open("#{RAILS_ROOT}/tmp/#{@user.name}'s Courses.ics", "wb") { |f| 
      f.write(
       "BEGIN:VCALENDAR
        CALSCALE:GREGORIAN
        X-WR-TIMEZONE;VALUE=TEXT:America/New_York
        METHOD:PUBLISH
        PRODID:-//The Friendly Bluebook//iCal Exporter V1.0//EN
        X-WR-CALNAME;VALUE=TEXT:#{@user.name}'s Courses
        VERSION:2.0

        BEGIN:VTIMEZONE
        TZID:America/New_York
        LAST-MODIFIED: #{Time.now.strftime(ical_time_format)}

        BEGIN:STANDARD
        DTSTART:20071104T020000
        RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=11
        TZOFFSETFROM:-0400
        TZOFFSETTO:-0500
        TZNAME:EST
        END:STANDARD

        BEGIN:DAYLIGHT
        DTSTART:20080309T020000
        RRULE:FREQ=YEARLY;BYDAY=2SU;BYMONTH=3
        TZOFFSETFROM:-0500
        TZOFFSETTO:-0400
        TZNAME:EDT
        END:DAYLIGHT

        END:VTIMEZONE\n".gsub(/        /, "")
      )

      # Create a map of days to how far in the future (from a start day of
      #   wednesday) they are
      distance = {"M" => 5, "T" => 6, "W" => 0, "Th" => 1, "F" => 2, 
        "S" => 3, "Su" => 4}

      # We have to iterate through the taking and shopping buckets
      courses = (@user.taking + @user.shopping).uniq.map{|c| Course.find(c)}
      courses.each do |course|
        # Make sure you set a recurrence for all times
        days = ["one", "two", "three", "four", "five"]
        days.each do |i|
          # Only do the work if there is an actual time
          if course["time_#{i}_start"]
            day = course["time_#{i}_start"].split(" ")[0]

            # Calculate the exact beginning time
            begin_time = course["time_#{i}_start"].split(" ")[1]
            begin_hour = begin_time.split(".")[0].to_i
            begin_hour = (begin_hour < 8 ? begin_hour + 12 : begin_hour)
            begin_minute = begin_time.split(".")[1].to_i

            # Calculate the exact ending time
            end_time = course["time_#{i}_end"].split(" ")[1]
            end_hour = end_time.split(".")[0].to_i
            end_hour = ((end_hour < 9 or end_time == "9.00") ? end_hour + 12 : 
              end_hour)
            end_minute = end_time.split(".")[1].to_i

            # Finally, write the output for the event to the file
            f.write(
              "\nBEGIN:VEVENT
               DTSTART;TZID=America/New_York:#{(classes_start + 
                    (distance[day] * 3600 * 24) +
                    (begin_hour * 3600) + (begin_minute * 60)
                  ).strftime(ical_time_format)}
               DTSTAMP:#{(classes_start + 
                    (distance[day] * 3600 * 24) +
                    (begin_hour * 3600) + (begin_minute * 60)
                  ).strftime(ical_time_format)}
               SUMMARY:#{course.title}
               RRULE:FREQ=WEEKLY;UNTIL=20111203T000000;INTERVAL=1
               UID:#{course.id}_#{i}
               DTEND;TZID=America/New_York:#{(classes_start + 
                    (distance[day] * 3600 * 24) +
                    (end_hour * 3600) + (end_minute * 60)
                  ).strftime(ical_time_format)}
               END:VEVENT\n".gsub(/               /, "")
             )
          end
        end
      end

      # Write the ending of the ICS to the file
      f.write("\nEND:VCALENDAR")
    }

    # Next, we send the file down to the user
    send_file "#{RAILS_ROOT}/tmp/#{@user.name}'s Courses.ics", 
      :type => "text/calendar"
  end

end
