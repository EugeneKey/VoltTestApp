class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.config.mailer_email_from
  layout 'mailer'
end
