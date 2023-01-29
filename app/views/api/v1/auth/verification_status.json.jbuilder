if @verification_code.present?
  json.started_code true
  json.expires_at @verification_code.expires_at
else
  json.started_code false
  json.expires_at nil
end
