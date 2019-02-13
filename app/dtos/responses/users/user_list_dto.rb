class UserListDto < BasePagedDto

  attr_accessor :users

  def initialize(users, users_count, base_path, page, page_size)
    super(users, users_count, base_path, page, page_size)
    @users = users
  end

end