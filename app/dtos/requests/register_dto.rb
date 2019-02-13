class RegisterDto < BaseRequestDto

  attr_accessor :sanitized_params

  def initialize(params)
    super(params)
    @sanitized_params = {}
    email = params[:email]
    username = params[:username]
    password = params[:password]
    first_name = params[:first_name]
    last_name = params[:last_name]
    password_confirmation = params[:password_confirmation]

    if email
      @sanitized_params.merge!(email: email.downcase)
    else
      add_error(:email, 'Email can not be blank')
    end

    if username
      @sanitized_params.merge!(username: username)
    else
      add_error(:username, 'username can not be blank')
    end

    if password
      @sanitized_params.merge!(password: password)
    else
      add_error(:password, 'Password can not be blank')
    end

    if first_name
      @sanitized_params.merge!(first_name: first_name)
    else
      add_error(:first_name, 'First name can not be blank')
    end

    if last_name
      @sanitized_params.merge!(last_name: last_name)
    else
      add_error(:last_name, 'Last name can not be blank')
    end

    if password_confirmation
      @sanitized_params.merge!(password_confirmation: password_confirmation)
    else
      add_error(:password, 'Password confirmation can not be blank')
    end
  end

  def valid?
    uv = username_valid?
    pv = password_valid?
    fnv = first_name_valid?
    lnv = last_name_valid?
    uv && pv && fnv && lnv
  end

  def last_name_valid?
    @sanitized_params.has_key?(:last_name)
  end

  def first_name_valid?
    @sanitized_params.has_key?(:first_name)
  end

  def password_valid?
    if @sanitized_params.has_key?(:password) && @sanitized_params.has_key?(:password_confirmation)
      if @sanitized_params[:password] == @sanitized_params[:password_confirmation]
      else
        add_error(:password, 'Password and password confirmation do not match')
        return false
      end
    else
      add_error(:password, 'You have to provide the password and password confirmation')
      return false
    end
    true
  end

  def username_valid?
    @sanitized_params.has_key?(:username)
  end

  def get_params
    @sanitized_params
  end
  def email_valid?
    if @email.present? and @email.match(URI::MailTo::EMAIL_REGEXP).present?
      add_error(:username, 'Not valid email')
      true
    end
    false
  end
end