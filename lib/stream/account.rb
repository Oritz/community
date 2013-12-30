class Stream::Account < Stream::Base
  attr_accessor :person

  def initialize(user, person, opts={})
    self.person = person
    super(user, opts)
  end

  def posts
    if user.present?
      if @person
        @posts = user.posts_from_user(@person)
      else
        @posts = user.posts_from_users
      end
    elsif @person
      @posts = @person.posts.all_public
    else
      raise "user and person can't be empty"
    end
  end
end
