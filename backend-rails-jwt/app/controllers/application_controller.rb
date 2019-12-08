class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
        token = request.headers['Authorization']

        hmac_secret = ENV['JWT_SECRET']
        

        begin
          @decoded_token = JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
          data= @decoded_token[0]
          @current_user=User.find_by(id: data["user_id"])
          render json: {user: @current_user}

        rescue ActiveRecord::RecordNotFound => e
          render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
          render json: { errors: e.message }, status: :unauthorized
        end

    end

#   def authorize_request
#     header = request.headers['Authorization']
#     header = header.split(' ').last if header
#     begin
#       @decoded = JsonWebToken.decode(header)
#       @current_user = User.find(@decoded[:user_id])
#     rescue ActiveRecord::RecordNotFound => e
#       render json: { errors: e.message }, status: :unauthorized
#     rescue JWT::DecodeError => e
#       render json: { errors: e.message }, status: :unauthorized
#     end
# end

 
 
end
