class AuthController < ApplicationController

  def login
    login_dto = LoginDto.new(params)
    if login_dto.valid?
      if login_dto.is_email?
        @user = User.find_by(email: login_dto.email)
      else
        @user = User.find_by(username: login_dto.username)
      end
      if @user && @user.authenticate(login_dto.password)
        @dto = LoginSuccessDto.new(@user)
        render 'users/login'
      else
        @dto = ErrorResponse.new({credentials: 'Invalid credentials'})
        render 'shared/errors'
      end
    else
      errors = login_dto.get_errors
      @dto = ErrorResponse.new(errors)
      render 'shared/errors'
      # render json: {success: false, full_messages: errors.values}
    end
  end
end