class ApplicationMailer < ActionMailer::Base
  default from: "Nebill<nebill@cuon.co.jp>",
          reply_to: "nebill@cuon.co.jp"
  layout 'mailer'
end
