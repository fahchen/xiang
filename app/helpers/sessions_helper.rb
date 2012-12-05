module SessionsHelper
  def sign_in
    session[:admin] = true
  end
  def sign_out
    session[:admin] = nil
  end

  def authenticate(params)
    params[:session][:login] == XiangSettings.login && params[:session][:password] = XiangSettings.password
  end

  def signed_in?
    session[:admin] == true
  end

  protected
  def url_after_sign_in
    admin_path
  end

  def url_after_sign_out
    root_path
  end

end
