class SessionsController < ApplicationController
  def new
    if signed_in?
      redirect_to url_after_sign_in
    else
     render template: 'sessions/new'
    end
  end

  def create
    if authenticate(params)
      sign_in
      redirect_to url_after_sign_in
    else
      render template: 'sessions/new', status: :unauthorized
    end
  end

  def destroy
    sign_out
    redirect_to url_after_sign_out
  end
end
