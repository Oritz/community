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
end
