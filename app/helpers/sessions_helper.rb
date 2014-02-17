module SessionsHelper
  def sign_in(user)
    #create new token
    remember_token = User.new_remember_token
    #put the token in the browser cookies
    cookies.permanent[:remember_token] = remember_token
    #save the token in the db
    #NOTE:  update_attribute bypasses the validations in the user model
    # which we have to do b/c we don't have the user password or confirmation
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    #set the current user to the given user
    self.current_user = user
  end

  #is the user signed in?
  #just check to see if current_user is nil
  def signed_in?
    #not(current_user.nil?)  so, if current_user is nil, we return false.  The ! inverts the answer
    # to make it answer the signed_in? question.
    #Oh...current_user calls the "get" function below rather than @current_user directly
    #And since this is the last assignment line in the method, the results are implicitly returned
    #just like return(blahblah)
    !current_user.nil?
  end

  #this is a method used strictly for assignment of "current_user"
  def current_user=(user)
    @current_user = user
  end

  #this method is called to get the current user
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    #if @current_user is undefined call find_by to get it...
    #otherwise, just return what you already have.
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  #check if the current_user eq the user param...return bool to answer
  def current_user?(user)
    user == current_user
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  #let's store the location in the session
  def store_location
    #we store the requested url if the request was a "get"
    session[:return_to] = request.url if request.get?
  end
end
