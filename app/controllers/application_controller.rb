class ApplicationController < ActionController::API
  GLOBAL_ERROR_CODES = {
    internal_error: 500,
    not_found: 404,
    wrong_params: 400
  }.freeze

  GLOBAL_ERROR_MESSAGES = {
    internal_error: 'Internal Server Error',
    not_found: 'Resource Not Found',
    wrong_params: 'Bad request'
  }.freeze

  private

  def render_error_from(object)
    error = object.failure
    status_code = error_status_code(error)
    error_message = error_message(error)

    render json: { error: error_message }, status: status_code
  end

  def error_status_code(error)
    code = GLOBAL_ERROR_CODES[error[:code]]
    raise StandardError "Error code could not be processed for error #{error}" if code.blank?

    code
  end

  def error_message(error)
    message = error[:message] || GLOBAL_ERROR_MESSAGES[error[:code]]
    raise StandardError "Error message could not be processed for error #{error}" if message.blank?

    message
  end
end
