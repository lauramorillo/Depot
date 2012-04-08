class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :prepare_time_for_display
  before_filter :authorize
  before_filter :set_i18n_locale_from_params
  
  private
  
  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end
  
  protected
  
  def prepare_time_for_display
    @current_time = Time.now
  end
  
  def authorize
    if User.count.zero?
      unless request.path_parameters[:controller] == "users" && (request.path_parameters[:action] == "new" || request.path_parameters[:action] == "create")
        redirect_to new_user_url, :notice => "Please create an admin"
      end
    else
      unless User.find_by_id(session[:user_id])
        redirect_to login_url, :notice => "Please log in"
      end
    end
  end
  
  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end
  
  def default_url_options
    {:locale => I18n.locale}
  end
end
