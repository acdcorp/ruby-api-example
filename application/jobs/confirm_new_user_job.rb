class ConfirmNewUserJob
  include SuckerPunch::Job

  def perform(email)
    Mail.deliver do
      from     'admin@sample.com'
      to       email
      subject  "Api Example: new user"
      body     "Your account was successfully created"
    end
  end
end
