class NotificationMailer < ActionMailer::Base
  default from: "no-reply@nomster-jm.com"
  
  def comment_added
      mail( to: "receiver", subject: "A comment has been added to your place")
  end
end
