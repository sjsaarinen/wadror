class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      if not user.disabled
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      else
        redirect_to :back, notice: "Your account is frozen, please contact admin"
      end
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def create_oauth

  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end