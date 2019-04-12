class SessionsController < ApplicationController

  def new
  end

  def create
    if @user = User.find_or_create_by(email: auth['info']['email']) do |u|
        u.username = auth['info']['name']
        u.uid = auth['uid']
        u.image = auth['info']['image']
        u.password = SecureRandom.hex(12)
      end
      session[:user_id] = @user.id
      redirect_to root_url
    else
      user = User.find_by(email: params[:session][:email])
      if user && user.authenticate(params[:session][:password])
        if user.activated?
          log_in user
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          redirect_back_or user
        else
          message = "account not activated"
          message += "check your email for the activation link"
          flash[:warning] = message
          redirect_to root_url
        end
      else
        flash.now[:danger] = 'invalid email/password combination'
        render 'new'
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  private

  def auth
    request.env['omniauth.auth']
  end

end
