module ApplicationHelper
  require 'sonkwo/exp'
  def level(exp)
    Sonkwo::Exp.level(exp)
  end
end
