class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  # def login
  #   @user = User.find_by_email(params[:email])
  #   if @user&.authenticate(params[:password])
  #     token = JsonWebToken.encode(user_id: @user.id)
  #     time = Time.now + 24.hours.to_i
  #     render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
  #                    username: @user.username }, status: :ok
  #   else
  #     render json: { error: 'unauthorized' }, status: :unauthorized
  #   end
  # end

  def login
    
    
    @user=User.find_by(email: params[:user][:email],password: params[:user][:password])
    
    if @user
      payload={user_id: @user.id}
      hmac_secret = ENV['JWT_SECRET']

      token = JWT.encode payload, hmac_secret, 'HS256'
      render json:{token: token}

    else
      render json:{error:'unauthorized'}
    end

    

    # if @user
    #   token = JsonWebToken.encode(user_id: @user.id)
    #       time = Time.now + 24.hours.to_i
    #       render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
    #                      username: @user.username }, status: :ok
    # else
    #   render json:{error:'unauthorized'}
    # end
  end

  private

  def login_params
    params.permit(:email, :password)
end
end
