class LoginSuccessDto < SuccessResponse
  attr_accessor :user, :token, :roles

  def initialize(user)
    @user = user
    @token = @user.generate_jwt
    @roles = @user.roles.collect {|r| r.name}
  end
end