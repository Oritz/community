namespace :posts do
  desc "Posts operations."

  task cleanall: :environment do
    puts "Clean all posts"

    Post.delete_all
    AccountsLikePost.delete_all
    Comment.delete_all
    Account.connection.execute("UPDATE accounts SET talk_count=0, subject_count=0, recommend_count=0")
    Group.connection.execute("UPDATE groups SET talk_count=0, subject_count=0, recommend_count=0")
  end
end
