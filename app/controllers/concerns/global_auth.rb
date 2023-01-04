module GlobalAuth
  extend ActiveSupport::Concern

  include SessionAuth
  include TokenAuth

  included do
    before_action :authenticate_user_by_token!
  end

  def authenticate_session_or_user!
    return head :unauthorized if current_user.blank? && current_session.blank?
  end
end
