class Api::ResetPasswordMailer < Api::MailerBase

  def perform(user_id)
    @user = Api::Models::User.where(id: user_id).first

    mail(
      to: @user.email,
      from: 'no-reply@sample.com',
      subject: 'Your password was reset!'
    )
  end

  def template_name
    'reset_password'
  end

end
