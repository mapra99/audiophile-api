json.array! @payments do |payment|
  json.partial! 'payment', payment: payment
end
