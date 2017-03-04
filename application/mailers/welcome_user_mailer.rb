class Api::WelcomeUserMailer < Api::MailerBase

  def perform(user_id)
    @user = Api::Models::User.where(id: user_id).first

    mail(
      to: @user.email,
      from: 'no-reply@sample.com',
      subject: 'Welcome!'
    )
  end

  def template_name
    'welcome_user'
  end

end
