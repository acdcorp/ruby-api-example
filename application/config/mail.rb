Mail.defaults do
  mail_uri = URI(MAIL_URL)
  delivery_method :smtp,
                  user_name: mail_uri.user,
                  password: mail_uri.password,
                  address: mail_uri.host,
                  port: mail_uri.port
end
