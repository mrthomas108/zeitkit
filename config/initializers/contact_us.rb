# Use this hook to configure contact mailer.
ContactUs.setup do |config|

  # ==> Mailer Configuration

  # Configure the e-mail address which email notifications should be sent from.  If emails must be sent from a verified email address you may set it here.
  # Example:
  # config.mailer_from = "contact@please-change-me.com"
  config.mailer_from = ENV['MAILER_DEFAULT_FROM']

  # Configure the e-mail address which should receive the contact form email notifications.
  config.mailer_to = ENV['MAILER_DEFAULT_FROM']

  # ==> Form Configuration

  # Configure the form to ask for the users name.
  config.require_name = false

  # Configure the form to ask for a subject.
  config.require_subject = false

  # Configure the form gem to use.
  # Example:
  # config.form_gem = 'formtastic'
  # config.form_gem = nil
  config.form_gem = 'simple_form'

  # Configure the redirect URL after a successful submission
  config.success_redirect = '/'

end

module ContactUs
  class ContactsController < ApplicationController
    skip_filter :require_login

    def create
      @contact = ContactUs::Contact.new(params[:contact_us_contact])

      if @contact.save
        redirect_to('/', :notice => t('contact_us.notices.success'))
      else
        flash[:error] = t('contact_us.notices.error')
        render_new_page
      end
    end

    def new
      @contact = ContactUs::Contact.new
      render_new_page
    end

    protected

    def render_new_page
      case ContactUs.form_gem
      when 'formtastic'  then render 'new_formtastic'
      when 'simple_form' then render 'new_simple_form', layout: "application"
      else
        render 'new'
      end
    end
  end
end
