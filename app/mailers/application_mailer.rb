class ApplicationMailer < ActionMailer::Base
  default from: I18n.t("mail.from"),
          reply_to: "nebill@cuon.co.jp"
  layout 'mailer'
end
