class ApplicationController < ActionController::API
  include JsonapiErrorsHandler
  class AuthorizationError < StandardError; end
  ErrorMapper.map_errors!(
    'ActiveRecord::RecordNotFound' => 'JsonapiErrorsHandler::Errors::NotFound'
  )
  rescue_from ::StandardError, with: ->(e) { handle_error(e) }
  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
  rescue_from AuthorizationError, with: :authorization_error

  before_action :authorize!

  private

  def authorize!
    raise AuthorizationError unless current_user
  end

  def access_token
    provided_token =  request.authorization&.gsub(/\ABearer\s/, '')
    @access_token = AccessToken.find_by(token: provided_token)
  end

  def current_user
    @current_user = access_token&.user
  end


  def authentication_error
    error =
      {
        status: '401',
        source: { pointer: '/code' },
        title: 'Authentication code is invalid',
        detail: 'You must provide a valid code in order to exchange it for token'
      }
    render json: { "errors": [error] }, status: 401
  end

  def authorization_error
    error =
      {
        status: '403',
        source: { pointer: '/headers/authorization' },
        title: 'Not authorized',
        detail: 'You have no right to access this resource.'
      }
    render json: { "errors": [error] }, status: 403
  end

  def attribute_errors(article)
    errors = []
    article.errors.messages.each do |attr, msg|
      errors << {
        source: { pointer: "/data/attributes/#{attr.to_s}" },
        detail: msg.join
      }
    end
    errors
  end

end
