module SessionAuth
  def authenticate_session_by_header!
    return head :unauthorized if current_session.blank?
  end

  def session_uuid
    @session_uuid ||= request.headers['X-SESSION-ID']
  end

  def current_session
    return if session_uuid.blank?

    @current_session ||= Session.find_by(uuid: session_uuid)
  end
end
