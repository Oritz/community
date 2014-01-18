module ApplicationHelper
  require 'sonkwo/exp'
  def level(exp)
    Sonkwo::Exp.level(exp)
  end

  def myself?(target)
    return false unless current_account
    target.id == current_account.id
  end

  def show_follow?(relation)
    return true if relation == Friendship::IRRESPECTIVE || relation == Friendship::FOLLOWER
    false
  end

  def show_unfollow?(relation)
    return true if relation == Friendship::FOLLOWING || relation == Friendship::MUTUAL
    false
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

  def machine_gb(value)
    (value / 1024.0).round(2)
  end
end
