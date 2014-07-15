class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_filter :check_user, only: [:new, :create]




  def destroy
    if User.find(params[:id]) == current_user
    flash[:error] = "Can't delete yourself"
    redirect_to users_url
    else
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
      end
  end


  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
      if @user.save
        sign_in @user
        redirect_to @user
        flash[:success] = "Welcome to Mark's App!"
      else
        render 'new'
      end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  private

  def check_user
    if signed_in?
      redirect_to root_url, notice: "You're already signed in."
      end
  end
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
 #before filters

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
