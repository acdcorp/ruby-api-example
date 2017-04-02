class SendResetPasswordCodeJob
  include SuckerPunch::Job

  def perform(email, code)
    Mail.deliver do
      from     'admin@sample.com'
      to       email
      subject  "Api Example: password reset code"
      body     "You will be able to reset your password within the next 30 minutes using this code: #{code}"
    end
  end
end
