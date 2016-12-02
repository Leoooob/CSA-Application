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