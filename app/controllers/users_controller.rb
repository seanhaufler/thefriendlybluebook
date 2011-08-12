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
    # First, we dynamically generate the ICS file
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
        LAST-MODIFIED: #{Time.now.strftime("%Y%m%dT%H%M%SZ")}

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

        END:VTIMEZONE

######## SAMPLE EVENT #######
        BEGIN:VEVENT
        SEQUENCE:5
        DTSTART;TZID=US/Pacific:20021028T140000
        DTSTAMP:20021028T011706Z
        SUMMARY:Coffee with Jason
        UID:EC9439B1-FF65-11D6-9973-003065F99D04
        DTEND;TZID=US/Pacific:20021028T150000
        BEGIN:VALARM
        TRIGGER;VALUE=DURATION:-P1D
        ACTION:DISPLAY
        DESCRIPTION:Event reminder
        END:VALARM
        END:VEVENT


        END:VCALENDAR".strip.gsub(/        /, "")
      )
    }

    # Next, we send the file down to the user
    send_file "#{RAILS_ROOT}/tmp/#{@user.name}'s Courses.ics", 
      :type => "text/calendar", :x_sendfile => true
  end

end
