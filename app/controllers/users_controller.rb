class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t("signup.welcome").concat(", " + @user.name)
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "error_messages.not_found_user"
      redirect_to root_path
    end
  end

  private
  def user_params
    params.require(:user).permit:name, :email, :password,
      :password_confirmation
  end
end
