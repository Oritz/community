class ApplicationController < ActionController::Base
  protect_from_forgery unless Rails.env.test?
  respond_to :html, :json
  layout :layout_by_resource

  before_filter :load_for_layout

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
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def forbid_callback(*args)
    raise "The action is forbidden"
  end

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  def load_for_layout
    if _layout == "application" && request.format != "json"
      @friends = Account.friends(current_account).limit(12).order("updated_at DESC") if current_account
      @tipoff_reasons = TipoffReason.all
    end
  end

  def qiniu_prepare(bucket, callback_name=nil, callback_params=nil)
    @cloud_storage_settings = CloudStorage.settings(current_account, bucket)
    @bucket = bucket
    @callback_name = callback_name
    @callback_params = callback_params.to_json
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
