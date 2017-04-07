class PasswordResetsController < ApplicationController
  before_action :find_user, only: [:create, :edit, :update]
  before_action :valid_user, :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t("password_reset.info")
      redirect_to root_url
    else
      flash.now[:danger] = t("password_reset.danger")
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t("password_reset.empty"))
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t("password_reset.reset")
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email].downcase
    unless @user
      flash[:danger] = t "error_messages.not_found_user"
    end
  end

  def valid_user
    unless @user && @user.activated? &&
      @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t("password_reset.expired")
      redirect_to new_password_reset_url
    end
  end
end
