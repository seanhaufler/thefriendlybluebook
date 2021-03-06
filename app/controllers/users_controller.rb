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

  The following takes a user's schedule and creates a visual calendar for it
=end
  def calendar
    # Create a standard mapping from day to left pos
    left_pos = {"M" => 0, "T" => 150, "W" => 300, "Th" => 450, "F" => 600}
  
    # First, we iterate through each of the user's buckets
    @courses = Array.new
    buckets = ["taking", "shopping", "avoiding"]
    buckets.each do |bucket|
      # Iterate through each course in the bucket and get it's info
      @user[bucket].map{|c| Course.find(c)}.each do |course|
        $POSSIBLE_TIMES.each do |i|
          if course["time_#{i}_start"]
            background = "#63DC90"
            color = "#00B945"
            if bucket == "shopping"
              background = "#FFB140"
              color = "#FF9700"
            elsif bucket == "avoiding"
              background = "#FF7D7D"
              color = "red"
            end

            # Calculate the proper height and offset from top
            begin_hour = course["time_#{i}_start"].split(" ")[1].split(".")[0].to_i
            begin_minute = course["time_#{i}_start"].split(" ")[1].split(".")[1].to_i
            end_hour = course["time_#{i}_end"].split(" ")[1].split(".")[0].to_i
            end_minute = course["time_#{i}_end"].split(" ")[1].split(".")[1].to_i
            time_length = ((end_hour - begin_hour) % 12) * 60 + 
              end_minute - begin_minute
            offset = ((begin_hour - 8) % 12) * 60 + begin_minute

            # Push on the course info
            @courses.push({ :id => course.id, :title => course.title,
              :day => course["time_#{i}_start"].split(" ")[0],
              :room => course.room, :time => course.time_string,
              :oci => course.oci_id,
              :listing => "#{course.department_abbr} #{course.number}",
              :left => left_pos[course["time_#{i}_start"].split(" ")[0]],
              :top => offset * 2 / 3, :height => time_length * 2 / 3 - 2, 
              :color => color, :background => background, :bucket => bucket
            })
          end
        end
      end
    end

    # Final page rendering work
    @stylesheets = ["pages/calendar"]
    @javascripts = ["pages/calendar", "library/facebook", "library/user"]
  end

=begin
  @params: none
  @path: /ical
  @before_filter: get_user
  @method: POST

  The following takes a user's schedule and creates an iCal feed for it
=end
  def ical
    # First, we create a couple of variables for the ical time format and class
    #   start date
    ical_time_format = "%Y%m%dT%H%M%S"      
    classes_start = Time.utc(2011, 8, 31, 0, 0, 0)
    iCal = Array.new
  
    # Next, we dynamically generate the ICS file (standard header)
    File.open("#{RAILS_ROOT}/tmp/#{@user.name}'s Courses.ics", "wb") { |f| 
      f.write(
       "BEGIN:VCALENDAR
        CALSCALE:GREGORIAN
        X-WR-RELCALID: FBB#{@user.facebook_id}#{@user.id}
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
      distance = {"MO" => 5, "TU" => 6, "WE" => 0, "TH" => 1, "FR" => 2, 
        "SA" => 3, "SU" => 4}
      iCalDays = {
          "M" => "MO", "T" => "TU", "W" => "WE", "Th" => "TH", "F" => "FR",
          "S" => "SA", "Su" => "SU",
      }
        
      # We have to iterate through the previously added courses
      courses = Array.new
      courses.concat(@user.ical.map{|c|
        {:course => Course.find(c), :cancel => true}
      })

      # Get the buckets from the command line
      buckets = params[:buckets] & $BUCKETS
      buckets.each do |bucket|
        courses.concat(@user[bucket].uniq.map{|c| 
          {:course => Course.find(c), :cancel => false}
        })
      end
      courses.uniq!

      # Iterate through each of the courses available
      courses.each do |hash|
        # Extract the actual course
        course = hash[:course]

        # Not a cancellation, add it to the new iCal set
        if not hash[:cancel]
          iCal << course.id
        end
                      
        # Make sure you set a recurrence for all times
        datetime_array = course.time_string.split(",")
        times = datetime_array.map{|t| t.split(" ")[1..3].join(" ")}
        days = datetime_array.map{ |t| 
            t.split(" ")[0].gsub(/Th|M|T|W|F|Su|S/, '\0 ').split(" ").map{ |day| 
              iCalDays[day]
            }
        }

        # Go through each time
        times.each_index do |i|
          # Calculate the exact beginning time
          begin_time = times[i].split(" - ")[0]
          begin_hour = begin_time.split(".")[0].to_i
          begin_hour = (begin_hour < 8 ? begin_hour + 12 : begin_hour)
          begin_minute = begin_time.split(".")[1].to_i

          # Calculate the exact ending time
          end_time = times[i].split(" - ")[1]
          end_hour = end_time.split(".")[0].to_i
          end_hour = ((end_hour < 9 or end_time == "9.00") ? end_hour + 12 : 
            end_hour)
          end_minute = end_time.split(".")[1].to_i

          # Finally, write the output for the event to the file
          days[i].sort!{|x, y| distance[x] <=> distance[y]}
          f.write(
            "\nBEGIN:VEVENT#{hash[:cancel]? "\nSEQUENCE: 1" : ""}
             DTSTART;TZID=America/New_York:#{(classes_start + 
                  (distance[days[i][0]] * 3600 * 24) +
                  (begin_hour * 3600) + (begin_minute * 60)
                ).strftime(ical_time_format)}
             DTSTAMP:#{(classes_start + 
                  (distance[days[i][0]] * 3600 * 24) +
                  (begin_hour * 3600) + (begin_minute * 60)
                ).strftime(ical_time_format)}
             SUMMARY:#{course.title}
             LOCATION:#{course.room}
             RRULE:FREQ=WEEKLY;UNTIL=#{hash[:cancel]? "10000000" : 
                "20111203"}T000000;BYDAY=#{days[i].join(",")}
             UID:#{course.id}_#{i}
             DTEND;TZID=America/New_York:#{(classes_start + 
                  (distance[days[i][0]] * 3600 * 24) +
                  (end_hour * 3600) + (end_minute * 60)
                ).strftime(ical_time_format)}
             END:VEVENT\n".gsub(/             /, "")
           )
        end
      end

      # Write the ending of the ICS to the file
      f.write("\nEND:VCALENDAR")
    }

    # Next, we update the events exported to the user's iCal
    @user.ical = iCal and @user.save

    # Finally, we send the file down to the user
    send_file "#{RAILS_ROOT}/tmp/#{@user.name}'s Courses.ics", 
      :type => "text/calendar"
  end

end
