json.array! @user_locations do |user_location|
  json.partial! 'user_location', user_location: user_location
  json.partial! 'location', location: user_location.location
end
