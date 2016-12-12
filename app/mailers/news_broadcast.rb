class NewsBroadcast < ApplicationMailer
  def send_news(user, broadcast, email_list)
    @firstname = user.firstname
    @content = broadcast.content

    mail to: user.email,
    subject: "Aber CS #{email_list} News",
    from: ADMIN_EMAIL
  end
end

##############################################
#Below is my working code for SendGrid, which is a Heroku addon to send automated emails.
#I haven't used it in my final submission because I didn't want to spam university email addresses
#or deal with failed sendings etc, spoofing them as above is good enough for me!

##class NewsBroadcast < ApplicationMailer
#  require 'sendgrid-ruby'
#  include SendGrid
#  
#  def send_news(user, broadcast, email_list)
#    @firstname = user.firstname
#    @content = broadcast.content
#    
#    from = ADMIN_EMAIL
#    subject = "Aber CS #{email_list}"
#    to = Email.new(email: user.email)
#    content = Content.new(type: 'text/plain', value: 'Hello, Email!')
#    
#    mail = Mail.new(from, subject, to, content)
#
#    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
#    response = sg.client.mail._('send').post(request_body: mail.to_json)
#    puts response.status_code
#    puts response.body
#    puts response.headers
#  end
#end