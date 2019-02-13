class UsersController < ApplicationController

  def create
    register_dto = RegisterDto.new(params)
    if register_dto.valid?
      @user = User.new(register_dto.get_params)
      if @user.save
        @dto = SuccessResponse.new('User created successfully')
        render 'shared/success'
        # render json: {success: true, full_messages: ['Done']}
      else
        @dto = ErrorResponse.new(@user.errors)
        render 'shared/errors'
        # render json: {success: false, full_messages: @user.errors.full_messages}
        # render json: ErrorSerializer.serialize(user.errors), status: 422
      end
    else
      @dto = ErrorResponse.new(register_dto.get_errors)
      render 'shared/errors'
    end
  end


  def secure_params
    params.require(:user).permit(:name, :password, :password_confirmation, :email)
  end
end