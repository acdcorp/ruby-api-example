class ConfirmResetPasswordJob
  include SuckerPunch::Job

  def perform(email)
    Mail.deliver do
      from     'admin@sample.com'
      to       email
      subject  "Api Example: password reset"
      body     "Your password was succesfully updated"
    end
  end
end
