class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        flash[:success] = t "page.login.success"
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t("mail.n_info") + t("mail.check")
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "page.login.error"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
