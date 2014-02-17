class UsersController < ApplicationController
  # do this before edit or update is called in this controller
  # basically...make sure the user is signed in
  # define actions to be performed before certain actions...
  # before index, edit, update, or destroy...perform signed_in_user
  #     make sure the user is signed in before those actions
  # before edit or update...perform correct_user
  #     make sure the correct user is performing edit/update
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,   only: [:destroy]

  def index
    # this gets a list of users...in one line...cool
    #...now it gets a specific page of users...in one line
    @users = User.paginate(page: params[:page])
  end

  def show
    #find the user by the id passed in on the URL
    #id is a number generated when the record is created
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      #going to @user should show the user profile page.
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    # we can get rid of the following line after we added the before_action for :correct_user
    # which defines @user for us
    #@user = User.find(params[:id])
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    #find and destroy the user
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  #================private stuff================
  private

  # this tells us what is allowed as far as user params...
  # user is required...and we permit name, email, password, and password confirmation
  #...but nothing else
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  #Before filters

  def signed_in_user
    unless signed_in?
      #let's remember the location that was requested
      store_location
      # send to sign in page unless user is already signed in
      # notice: is shorthand for flash[:notice] when passed to "redirect_to"
      # doesn't work for :success or :error
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
