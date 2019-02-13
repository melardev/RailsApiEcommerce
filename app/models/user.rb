class User < ApplicationRecord
  # this uses bcrypt so make sure to add it in your Gemfile
  has_secure_password

  has_one :cart
  has_many :orders
  has_many :products_shares
  has_many :addresses, class_name: 'Address'
  has_and_belongs_to_many :roles, :join_table => :users_roles
  # has_many :cart_items, through: :carts

  scope :without_cart, -> {User.where(cart: nil)}
  # https://stackoverflow.com/questions/17372886/whats-the-rails-4-way-of-finding-some-number-of-random-records
  scope :random_users, -> {order(Arel::Nodes::NamedFuction.new('RANDOM', []))}
  scope :random_ids, -> (how_many) {User.ids.sample(how_many)}
  scope :random_id, -> {User.ids.shuffle.first}
  scope :random_user, -> {User.find(User.pluck(:id).shuffle.first)}
  scope :random_users, ->(how_many) {User.where(id: User.pluck(:id).sample(how_many))}
  scope :random_users3, -> (how_many) {User.all.sample(how_many)}


  after_initialize :init

  def init
    if roles.empty?
      role = Role.create_with(description: 'only for authors').find_or_create_by(name: 'ROLE_USER')
      self.roles.append role
      #self.number  ||= 0.0
    end
  end

  def generate_jwt
    JWT.encode({id: id, user_id: id, roles: roles.collect {|r| r.name}, exp: 60.days.from_now.to_i, email: self.email, username: self.username},
               'JWT_SUPER_SECRET')
  end

  def is_admin?
    role_admin = Role.find_by(name: 'ROLE_ADMIN')
    roles.include?(role_admin)
  end
end
