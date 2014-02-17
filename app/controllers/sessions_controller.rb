class SessionsController < ApplicationController

  def new
  end

  def create
    #emails are stored in lowercase, so downcase and look for a match
    user = User.find_by(email: params[:session][:email].downcase)

    #if we found the user and the password works...
    if user && user.authenticate(params[:session][:password])
      sign_in user
      # this is our special function that will remember the originally requested url
      redirect_back_or user
    else #user not found or invalid password
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  #signout and go to root url
  def destroy
    sign_out
    redirect_to root_url
  end
end