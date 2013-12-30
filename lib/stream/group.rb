class Stream::Group < Stream::Base
  attr_accessor :group

  def initialize(user, group, opts={})
    self.group = group
    super(user, opts)
  end

  def posts
    # user.present? && group : posts in a group with user presented
    # user.present? && !group : posts in all groups the user added
    # !user.present? && group : posts in a group
    # !user.present? && !group : raise an error
    if user.present?
      @posts ||= @group ? user.posts_from_group(@group) : user.posts_from_groups
    elsif @group
      @posts = @group.posts.all_public
    else
      raise "group and user can't be empty"
    end
  end
end
