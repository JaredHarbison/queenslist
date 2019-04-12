class StaticPagesController < ApplicationController
  
  def home
    @user = User.find(session[:user_id]) if session[:user_id]
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def about
  end

end

#scope :season_seven, -> {where()}
