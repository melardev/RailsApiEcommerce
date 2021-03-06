json.success true
# json.(@user, :id, :email, :username, :roles)
json.user do
  json.(@user, :id, :email, :username)
  json.roles do |json|
    json.array! @user.roles, partial: 'roles/role_only_name', as: :role
  end

  json.roles @roles
end

json.token @user.generate_jwt
json.scheme 'Bearer'