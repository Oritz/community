module ApplicationHelper
  require 'sonkwo/exp'
  def level(exp)
    Sonkwo::Exp.level(exp)
  end

  def show_account_info?
    if current_account && current_account.update_tag.to_i >= Account::UPDATE_TAG_FINISH
      true
    else
      false
    end
  end

  def check_access?(options={})
    options[:auth_item] ||= "oper_#{params[:controller]}_#{params[:action]}"
    auth_item_name = options.delete(:auth_item)
    auth_item = AuthItem.where(name: auth_item_name).first
    return true unless auth_item
    current_account.check_access?(auth_item, options)
  end
end
