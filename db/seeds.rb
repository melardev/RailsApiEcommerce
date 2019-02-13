# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'pry'


def random_date_between(first, second)
  number_of_days = (first - second).abs
  [first, second].min + rand(number_of_days)
end


def seed_user_role
  # Create user_role if does not exist
  user_role = Role.create_with(description: 'authenticated users').find_or_create_by(name: 'ROLE_USER')
end

def seed_standard_users
  users_count = User.includes(:roles).where(roles: {name: 'ROLE_USER'}).count
  users_to_seed = 32
  puts "[+] Seeding #{users_to_seed - users_count} users"
  (users_to_seed - users_count).times do |_index|
    User.create(
        first_name: Faker::Name::first_name,
        last_name: Faker::Name::last_name,
        username: Faker::Name.first_name,
        email: Faker::Internet.email,
        password: 'password',
        password_confirmation: 'password',
    )
  end
end

def seed_admin_role
  puts "[+] Seeding admin role"
  Role.create_with(description: 'admin users').find_or_create_by(name: 'ROLE_ADMIN')
end

def seed_admin_user(admin_role)
  admin = User.find_by(username: 'admin')
  puts "[+] Seeding Admin"
  unless admin
    admin = User.new(
        username: 'admin',
        first_name: 'adminFN',
        last_name: 'adminLN',
        email: 'admin@ror_shop_api.com',
        roles: [admin_role],
    )
    admin.password = 'password'
    admin.password_confirmation = 'password' # this is needed when using has_secure_password as we are in this app
    admin.save!
  end
end

def seed_admin_feature
  role_admin = seed_admin_role
  seed_admin_user(role_admin)
end

def seed_products
  products_count = Product.count
  products_to_seed = 47
  if products_to_seed > products_count
    # read a good explanation on http://tomdallimore.com/blog/includes-vs-joins-in-rails-when-and-where/
    puts "[+] Seeding #{products_to_seed - products_count} Products"
    (products_to_seed - products_count).times do |index|
      puts "seeding product number #{index}"
      tags_to_add = [0, rand(Tag.count)].min
      tags_to_add = [tags_to_add, 3].max # no more than 3 tags
      tags = Set[]
      # tags = Tag.where(id: Tag.pluck(:id).sample(tags_to_add))
      tags_to_add.times do |_i|
        tags.add Tag.offset(rand(Tag.count)).first
      end

      categories_to_add = [0, rand(Category.count)].min
      categories_to_add = [categories_to_add, 3].max # no more than 3 categories
      categories = Set[]
      categories_to_add.times do |_i|
        categories.add Category.offset(rand(Category.count)).first
      end

      product = Product.new(
          name: Faker::Lorem.sentence,
          description: Faker::Lorem.paragraph(3),
          price: ((2300.0 - 100.0) * rand + 100).round(2),
          publish_on: random_date_between(Date.civil(2016, 1, 1), Date.civil(2020, 1, 1)),
          stock: Faker::Number.between(0, 1000),
          tags: tags.to_a, # to array
          categories: categories.to_a,
      )

      product.save!
      ProductImage.create(product: product, file_size: Faker::Number.between(5000, 17000), file_path: Faker::File.file_name('images/products', nil, 'png'), file_name: Faker::String.random(6) + '.png', original_filename: Faker::String.random(6) + '.png')
    end
  end
end

def seed_comments
  comments_count = Comment.count
  comments_to_seed = 22

  if comments_to_seed > comments_count
    puts "[+] Seeding #{comments_to_seed - comments_count} Comments"
    (comments_to_seed - comments_count).times do |_i|
      Comment.create!(
          content: Faker::Lorem.sentence,
          product: Product.offset(rand(Product.count)).first,
          user: User.offset(rand(User.count)).first,
          rating: ((Faker::Boolean.boolean 0.7) ? Faker::Number.between(1, 5) : nil),
      )
    end
  end
end

def seed_tags
  Tag.create_with(description: 'For kids').find_or_create_by(name: 'kids') do |tag|
    tag.images.build(type: TagImage.name, file_size: Faker::Number.between(5000, 17000), file_path: Faker::File.file_name('images/tags', nil, 'png'), file_name: Faker::String.random(6) + '.png', original_filename: Faker::String.random(6) + '.png')
  end
  Tag.create_with(description: 'For teenagers').find_or_create_by(name: 'teenagers') do |tag|
    tag.images.build(type: TagImage.name, file_size: Faker::Number.between(5000, 17000), file_path: Faker::File.file_name('images/tags', nil, 'png'), file_name: Faker::String.random(6) + '.png', original_filename: Faker::String.random(6) + '.png')
  end

  Tag.create_with(description: 'For adults').find_or_create_by(name: 'adults') do |tag|
    tag.images.build(tag_id: tag.id, type: TagImage.name, file_size: Faker::Number.between(5000, 17000), file_path: Faker::File.file_name('images/tags', nil, 'png'), file_name: Faker::String.random(6) + '.png', original_filename: Faker::String.random(6) + '.png')
  end

end

def seed_categories
  Category.create_with(description: 'uncategorized products').find_or_create_by(name: 'uncategorized') do |category|
    category.images.build(type: CategoryImage.name, file_size: Faker::Number.between(5000, 17000), file_path: Faker::File.file_name('images/categories', nil, 'png'), file_name: Faker::String.random(6) + '.png', original_filename: Faker::String.random(6) + '.png')
  end


Category.create_with(description: 'Shoes for everyone!').find_or_create_by(name: 'shoes') do |category|
    category.images.build(type: CategoryImage.name, file_size: Faker::Number.between(5000, 17000), file_path: Faker::File.file_name('images/categories', nil, 'png'), file_name: Faker::String.random(6) + '.png', original_filename: Faker::String.random(6) + '.png')
  end

  Category.create_with(description: 'Pants for everyone').find_or_create_by(name: 'pants') do |category|
    category.images.build(file_size: Faker::Number.between(5000, 17000), file_path: Faker::File.file_name('images/categories', nil, 'png'), file_name: Faker::String.random(6) + '.png', original_filename: Faker::String.random(6) + '.png')
  end

  Category.create_with(description: 'jeans for everyone').find_or_create_by(name: 'jeans') do |category|
    category.images.build(type: CategoryImage.name, file_size: Faker::Number.between(5000, 17000), file_path: Faker::File.file_name('images/categories', nil, 'png'), file_name: Faker::String.random(6) + '.png', original_filename: Faker::String.random(6) + '.png')
  end

  Category.create_with(description: 'It is cold, do you want a jacket?').find_or_create_by(name: 'jackets') do |category|
    ci = category.images.build(type: CategoryImage.name, file_size: Faker::Number.between(5000, 17000), file_path: Faker::File.file_name('images/categories', nil, 'png'), file_name: Faker::String.random(6) + '.png', original_filename: Faker::String.random(6) + '.png')
    ci.save
  end

end

def seed_addresses
  addresses_count = Address.count
  addresses_to_seed = 40
  addresses_to_seed -= addresses_count
  if addresses_to_seed > 0
    puts "[+] Seeding #{addresses_to_seed} Addresses"
    addresses_to_seed.times do |_i|
      user = ((Faker::Boolean.boolean 0.8) ? User.random_user : nil)
      if not user.nil?
        first_name = user.first_name
        last_name = user.last_name
      else
        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name
      end
      Address.create!(
          user: user,
          city: Faker::Address.city,
          country: Faker::Address.country,
          zip_code: Faker::Address.zip_code,
          address: Faker::Address.street_address,
          first_name: first_name,
          last_name: last_name
      )
    end
  end
end

def seed_orders
  orders_count = Order.count
  orders_to_seed = 10

  if orders_to_seed > orders_count
    puts "[+] Seeding #{orders_to_seed - orders_count} Orders"
    (orders_to_seed - orders_count).times do |_i|
      address = Address.random_address
      order = Order.create!(
          user_id: address.user_id,
          address: address
      )
=begin
      order.build_order_info(
          city: Faker::Address.city,
          country: Faker::Address.country,
          zip_code: Faker::Address.zip_code,
          address: Faker::Address.street_address,
          )
=end
    end
  end

  order_items_count = OrderItem.count
  order_items_to_seed = 10

  if order_items_count < order_items_to_seed
    puts "[+] Seeding #{order_items_to_seed - order_items_count } OrderItems"
    (order_items_to_seed - order_items_count).times do |_i|

      #product order = Order.get_random_empty
      order = Order.get_orders_with_empty_order_items.first

      (((5 - 1) * rand + 1).to_i).times do
        product = Product.products_not_in_order(order).first
        order.order_items.create!(
            name: product.name,
            slug: product.slug,
            user_id: order.user_id,
            product: product,
            quantity: ((5 - 1) * rand + 1).to_i,
            price: (product.price + (rand(-20.0..20.0))).round(2)
        )
      end
    end
  end
end


def seed
  seed_admin_feature
  seed_standard_users
  seed_tags
  seed_categories
  seed_products
  seed_comments
  seed_addresses
  seed_orders
end

seed