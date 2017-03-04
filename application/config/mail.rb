require 'mail'

Mail.defaults do
  if %w(development test).include?(RACK_ENV)
    require 'letter_opener'

    delivery_method LetterOpener::DeliveryMethod, :location => File.expand_path('../../../tmp/letter_opener', __FILE__)
  else
    delivery_method :sendmail
  end
end
