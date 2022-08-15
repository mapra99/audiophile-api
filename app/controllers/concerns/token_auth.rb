module TokenAuth
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user_by_token!
  end

  private

  def authenticate_user_by_token!
    return head :unauthorized if current_user.blank?
  end

  def bearer_token
    @bearer_token ||= request.headers['Authorization']&.gsub(/^Bearer /, '')
  end

  def access_token
    @access_token ||= AccessToken.active.find_by(token: bearer_token)
  end

  def current_user
    return if bearer_token.blank?
    return if access_token.blank?

    @current_user ||= access_token.user
  end
end
