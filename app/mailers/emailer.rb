class Emailer < ActionMailer::Base
  include ApplicationHelper
  helper :application
    
  default :from => "notifications@thefriendlybluebook.com",
          :reply_to => $WEBSITE_CONTACT
  
  def exception_report(exception, path, user, params)
    subject = "Exception raised by #{user ? user.email : "generic user"}"
    mail(:to => $WEBSITE_CONTACT, :from => $WEBSITE_CONTACT, :subject => subject) do |format|
      format.text { 
        render :text => path + "\n\nParams: " + params.to_json + 
          "\n\n" + exception.message.to_s + "\n\n" + 
          (exception.backtrace ? exception.backtrace.join("\n") : "") 
      }
      format.html { 
        render :text => path + "<br /><br />Params: " + params.to_json + 
          "<br /><br />" + exception.message.to_s + "<br /><br />" + 
          (exception.backtrace ? exception.backtrace.join("<br />") : "") 
      }
    end
  end
end
