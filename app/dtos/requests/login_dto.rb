class LoginDto < BaseRequestDto

  attr_accessor :password, :email, :username

  def initialize(params)
    super(params)
    @username =  params[:username]
    @email = params[:email]
    @password = params[:password]
    @errors = {}
  end

  def is_email?
    not @email.blank?
  end

  def is_username?
    not @username.blank?
  end

  def valid?
    if is_email?
      uev = email_valid?
    else
      uev = username_valid?
    end

    pv = password_valid?
    uev && pv
  end

  def email_valid?
    @email.match(URI::MailTo::EMAIL_REGEXP).present?
  end

  def password_valid?
    if @password.blank?
      add_error(:password, 'Password can not be blank')
      return false
    end
    true
  end

  def add_error(symbol, message)
    if @errors.has_key?(symbol)
      @errors[symbol].append message
    else
      @errors.merge!({symbol => [message]})
    end
  end

  def username_valid?
    if @username.blank?
      add_error(:username, 'Username can not be blank')
      return false
    end
    true
  end

end