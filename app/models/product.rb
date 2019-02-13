class Product < ApplicationRecord

  # Assotiations
  has_many :cart_items, dependent: :destroy # product_id in cart_items table

  has_many :comments
  has_many :order_items
  has_many :orders, through: :order_items # cart_item_id in orders -> product_id in orders
  has_many :products_shares

  has_and_belongs_to_many :tags, :join_table => :products_tags
  has_and_belongs_to_many :categories, :join_table => :products_categories

  has_many :images, class_name: 'ProductImage'
  # before_destroy :ensure_not_referenced_by_any_cart_item


  # ===============
  # = Validations =
  # ===============
  validates :name, uniqueness: true
=begin
  validates :image_url, allow_blank: true, format: {
      with: %r{\.(gif|jpg|png)\Z}i,
      message: 'must be a URL for GIF, JPG or PNG image.'
  }
=end

  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :slug, uniqueness: true

  validates :name, presence: true, allow_blank: false, length: {minimum: 1, maximum: 500}
  validates :description, presence: true, allow_blank: false, length: {minimum: 2}


  # validates :name, :description, :image_url, presence: true

  enum content_type: [:raw, :html, :markdown]


  # ==========
  # = Scopes =
  # ==========
  scope :not_in_cart, ->(cart) {joins(:cart_items).where.not(cart_items: {cart: cart})}
  # Product.left_outer_joins(:cart_items).where('cart_items.product_id': nil)
  scope :not_referenced_by_any_cart_item, -> {left_outer_joins(:cart_items).where('cart_items.product.id': nil)}
  # TODO: Alias ...
  scope :not_in_any_cart, -> {left_outer_joins(:cart_items).where('cart_items.product.id': nil)}
  scope :rated_by, -> (username) {joins(:ratings).where(ratings: {user: User.where(username: username)})}
  scope :for_weight, -> (weight) {where('min_weight <= ? AND max_weight >= ?', weight, weight)}
  scope :products_in_cart, ->(cart) {joins(:cart_items).where('cart_items.cart_id': cart.id)}
  # Product.joins(:cart_items).where.not(id: [Product.joins(:cart_items).where('cart_items.cart_id': 3)]).size
  scope :products_not_in_cart, ->(cart) {left_outer_joins(:cart_items).where.not(id: [Product.joins(:cart_items).where('cart_items.cart_id': cart.id)])}
  # A user can like once, so uniquenes for two columns: user_id and article_id

  scope :products_in_order, ->(order) {includes(:order_items).where('order_items.order_id': order.id)}
  scope :products_not_in_order, ->(order) {Product.where.not(id: Product.products_in_order(order))}
  # Articles written by a user given a username
  scope :from_user, ->(username) {where(user: User.where(username: username))}
  scope :rating_avg, -> {}
  # Product tagged with a given tag name
  scope :tagged_with, ->(tag) {joins(:tags).where(tags: {name: tag})}

  # Articles categories with give ncategory name
  # Article.includes(:categories).where(:categories=>{name: 'sports'})
  scope :categorised_as, ->(name) {joins(:categories).where(:categories => {name: name})}

  # ===========
  # = Methods =
  # ===========
  after_initialize :set_default_content_type, :if => :new_record?
  before_save :init

  def set_default_content_type
    # now we will have html? raw? markdown? methods, ActiveRecord is cool <3
    self.content_type ||= :html
  end

  # before_save will be too late, because it would faile the validation, so after_initialize is a good one
  # https://stackoverflow.com/questions/6249475/ruby-on-rails-callback-what-is-difference-between-before-save-and-before-crea
  before_validation do
    self.slug ||= "#{name.to_s.parameterize}"
  end

  def init
    if tags.empty?
      puts 'empty tags'
      tag = Tag.create_with(description: 'untagged articles').find_or_create_by(name: 'untagged')
      self.tags.append tag
    end

    if categories.empty?
      category = Category.create_with(description: 'uncategorised articles').find_or_create_by(name: 'uncategorised')
      self.categories.append category
    end
  end

  def rating_average
    rating_values = ratings.map(&:rating)
    (rating_values.inject {|sum, rating| sum + rating}.to_f / rating_values.size).round(2)
  end

end
