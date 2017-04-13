class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create]
  before_action :find_user, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.paginate page: params[:page],
      per_page: Settings.pagination.per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "mail.mail_check"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @microposts = @user.microposts.order_desc.paginate page: params[:page]
    @current_user_build_relationship = current_user.active_relationships.build
    @current_user_destroy_relationship = current_user.active_relationships
      .find_by followed_id: @user.id
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "page.edit.success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "page.index.delete"
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit:name, :email, :password,
      :password_confirmation
  end

  def correct_user
    redirect_to root_url unless @user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "error_messages.not_found_user"
      redirect_to root_path
    end
  end
end
