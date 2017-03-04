class Api::MailerBase
  include ERB::Util

  def mail(from:, to:, subject:)
    mailer = Mail.new do
      to      to
      from    from
      subject subject
    end

    if template?(:text)
      mailer.text_part = Mail::Part.new
      mailer.text_part.body = render_template(:text)
    end

    if template?(:html)
      mailer.html_part = Mail::Part.new
      mailer.html_part.content_type = 'text/html; charset=UTF-8'
      mailer.html_part.body = render_template(:html)
    end

    mailer.deliver
  end

  def template_name
    raise NotImplementedError
  end

  protected

  def template?(extension)
    template_exists?(template_path(extension))
  end

  def render_template(extension)
    render(File.read(template_path(extension)))
  end

  def template_path(extension)
    File.expand_path("../templates/#{template_name}.#{extension}.erb", __FILE__)
  end

  def template_exists?(path)
    File.exists?(path)
  end

  def render(template)
    ERB.new(template).result(binding)
  end

end
