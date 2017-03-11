class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && user.not_activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = 'You have activated your account!'
      redirect_to user
    else
      flash[:danger] = 'Invalid activation link.'
      redirect_to root_url
    end
  end
end
