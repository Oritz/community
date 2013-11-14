class ApplicationController < ActionController::Base
  protect_from_forgery unless Rails.env.test?
  respond_to :html, :json
  layout :layout_by_resource

  def sonkwo_authenticate_account
    case request.format
    when 'json'
      render(json: {
               status: 'fail',
               data: {
                 code: 401,
                 message: I18n.t('controllers.need_login')
               }
             }) unless current_account
    else
      authenticate_account!
    end
  end

  protected
  def forbid_callback(*args)
    raise "The action is forbidden"
  end

  def layout_by_resource
    if devise_controller?
      'devise_accounts'
    else
      'application'
    end
  end

  def check_access?(options={})
    options[:auth_item] ||= "oper_#{params[:controller]}_#{params[:action]}"
    auth_item_name = options.delete(:auth_item)
    auth_item = AuthItem.where(name: auth_item_name).first
    return true unless auth_item
    if current_account.check_access?(auth_item, options)
      true
    else
      respond_to do |format|
        format.html { render status: :forbidden, text: "forbidden" }
        format.json { render json: {status: "error", message: "forbidden"} }
      end
      false
    end
  end
end
