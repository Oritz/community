class InformationsController < ApplicationController
  before_filter :sonkwo_authenticate_account
  before_filter :check_upate_tag

  def interests
  end

  def groups
    respond_to do |format|
      format.html
      format.json do
        max_id = Group.maximum(:id)
        min_id = Group.minimum(:id)
        ids = [*min_id..max_id].sample(9)
        @groups = Group.joins("LEFT JOIN groups_accounts ON group_id=id AND account_id=#{current_account.id}")
          .select("groups.id, groups.name, groups.member_count, groups.description, account_id")
          .where("id IN (?)", ids)
        render json: { status: "success", data: @groups }
      end
    end
  end

  def friends
    respond_to do |format|
      format.html
      format.json do
        data = []
        @accounts = Account.order("follower_count").limit(6)
        ids = @accounts.collect { |a| a.id }
        @friendship = Friendship.where("account_id IN (?) AND follower_id=#{current_account.id}", ids)
        @accounts.each do |account|
          data_item = {}
          data_item[:id] = account.id
          data_item[:nick_name] = account.nick_name
          data_item[:level] = account.level
          data_item[:following_count] = account.following_count
          data_item[:follower_count] = account.follower_count
          data_item[:post_count] = account.talk_count + account.subject_count + account.recommend_count
          data_item[:account_id] = nil
          @friendship.each do |item|
            if item.account_id == account.id
              data_item[:account_id] = current_account.id
              break
            end
          end

          data << data_item
        end

        render json: { status: "success", data: data }
      end
    end
  end

  def clients
  end

  def tags
    max_id = Tag.maximum(:id)
    min_id = Tag.minimum(:id)
    ids = [*min_id..max_id].sample(28)
    @tags = Tag.joins("LEFT JOIN accounts_tags ON account_id=#{current_account.id} AND tag_id=id").select("tags.*, account_id").where("id IN (?)", ids)
    respond_to do |format|
      format.html
      format.json { render json: { status: "success", data: @tags } }
    end
  end

  private
  def check_upate_tag
    not_found if current_account.update_tag
  end
end
