class Stream::Base
  attr_accessor :min_id, :user, :order

  def initialize(user, opts={})
    self.user = user
    self.min_id = opts[:min_id]
    self.order = opts[:order]
  end

  def posts
    Post.scoped
  end

  def stream_posts
    self.posts.for_a_stream(min_id, order, self.user)
  end
end
