class Relation::Account < Relation::Base
  attr_accessor :target, :relation_type

  def initialize(user, target, relation_type, opts={})
    opts[:relation_type] ||= "stars"
    self.relation_type = relation_type
    self.target = target
    super(user, opts)
  end

  def accounts
    case relation_type
    when "stars"
      @accounts ||= target.stars
    when "fans"
      @accounts ||= target.fans
    when "friends"
      @accounts ||= Account.friends(target)
    else
      raise "wrong relation_type"
    end
  end
end
