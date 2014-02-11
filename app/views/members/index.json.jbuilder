json.array! @members do |member|
  json.extract! member, :id, :is_admin
  json.user do
    json.extract! member.user, :id, :email, :name
  end
end
