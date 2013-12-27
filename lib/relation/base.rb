class Relation::Base
  # TODO: delete the paginate information
  attr_accessor :user, :order, :page, :limit, :offset, :paginate

  def initialize(user, opts={})
    self.user = user
    self.order = opts[:order]
    self.paginate = opts[:paginate]
    self.limit = opts[:limit]
    self.offset = opts[:offset]
  end

  def accounts
    Account.scoped
  end

  def relation_accounts
    if self.paginate
      self.accounts.order(self.order).page(paginate[:page]).per(paginate[:per]).tap do |accounts|
        relation_with_accounts!(accounts)
      end
    else
      self.accounts.order(self.order).limit(limit).offset(offset).tap do |accounts|
        relation_with_accounts!(accounts)
      end
    end
  end

  protected
  def relation_with_accounts!(accounts)
    return accounts unless @user

    ids = accounts.map(&:id)
    friendship = Friendship.where("(account_id=? AND follower_id IN (?)) OR (follower_id=? AND account_id IN (?))", @user.id, ids, @user.id, ids).select("account_id, follower_id, is_mutual")
    friendship_hash = friendship.inject({}) do |hash, f|
      if f.account_id == @user.id
        hash[f.follower_id] = f.is_mutual == Friendship::IS_MUTUAL ? Friendship::MUTUAL : Friendship::FOLLOWER
      else
        hash[f.account_id] = f.is_mutual == Friendship::IS_MUTUAL ? Friendship::MUTUAL : Friendship::FOLLOWING
      end
      hash
    end

    accounts.each do |account|
      if account.id == @user.id
        account.relationship = Friendship::IS_SELF
      else
        account.relationship = friendship_hash[account.id]
      end
    end
  end
end
