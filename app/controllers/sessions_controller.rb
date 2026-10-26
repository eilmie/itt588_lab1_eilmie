class SessionsController < ApplicationController
  def new
  end

  def create
    username = params[:username]
    password = params[:password]
    authenticated = false
    user_role = nil

    # Iterates through the credential file securely
    File.foreach(Rails.root.join('Password.txt')) do |line|
      user, pass, role = line.chomp.split(',')
      
      # Validates credentials
      if user == username && pass == password
        authenticated = true
        user_role = role
        break
      end
    end

    # Session assignment and user feedback
    if authenticated
      session[:user_id] = username 
      session[:role] = user_role
      flash[:notice] = "Login successful! Welcome, #{username.capitalize} (Role: #{user_role})."
      redirect_to root_path
    else
      flash[:error] = "Invalid username or password. Please try again."
      redirect_to login_path
    end
  end
 

  def destroy
    # Clears session data for secure logout
    session[:user_id] = nil
    session[:role] = nil
    flash[:notice] = "You have successfully logged out."
    redirect_to login_path
  
  end
end
