json.success true
# json.(@user, :id, :email, :username, :roles)
json.user do
  json.(@dto.user, :id, :email, :username)
  json.roles @dto.roles
end

json.token @dto.user.generate_jwt
json.scheme 'Bearer'