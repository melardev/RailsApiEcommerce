class ApplicationController < ActionController::API
  # protect against CSRF, all form CSRF tokens will be managed automatically

  before_action :authenticate_user

  #rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActionController::ParameterMissing, :with => :bad_request

  def render_error(error_messages)
    @dto = ErrorResponse.new(error_messages)
    render 'shared/errors'
  end

  def render_success(success_messages)
    @dto = SuccessResponse.new(success_messages)
    render 'shared/success'
  end

  def bad_request(err)
    puts err
  end

  def record_not_found
    render json: {success: false, full_messages: ['Resource not found']}
  end

  def authenticate_user
    # Return unauthorized if invalid JWT, login if valid, continue as guest otherwise
    @authenticated = false
    if request.headers['Authorization'].present?
      token = request.headers['Authorization'].scan(/Bearer (.*)$/).flatten.last
      begin
        # The third argument is the algorithm, by default it uses HS256, override
        jwt_payload = JWT.decode(token, 'JWT_SUPER_SECRET', 'HS512').first

        @current_user_id = jwt_payload['id']
        @authenticated = true
        @current_user = User.find(jwt_payload['id'])
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        # head :unauthorized
        render json: {success: false, errors: {full_messages: ['Not authenticated, token must be provided and not expired']}}
      end
    end
  end

  def logged_in?
    current_user
  end

  def generate_jwt(user)
    JWT.encode({id: user.id, exp: 7.days.from_now.to_i, email: user.email, username: user.username},
               'JWT_SUPER_SECRET')
  end

  ############################
  def authorize!
    render json: {success: false, error: 'Permission denied'}, status: 401 unless @current_user
  end

  def current_user
    @user ||= User.find(@token[:user_id]) if get_token
    @user || errors.add(:token, 'Invalid token') && nil
  end

  private

  attr_reader :headers

  def get_token
    # JWT.decode(token, Rails.application.secret_key_base).first
    @token ||= JsonWebToken.decode(get_token_from_header)
  end

  def get_token_from_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      errors.add(:token, 'Missing token')
    end
    nil
  end

  def only_admin!
    if @current_user.nil? or not @current_user.is_admin?
      render_error('Permission denied')
    end
  end
end
