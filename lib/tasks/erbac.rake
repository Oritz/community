namespace :erbac do
  desc "Create access control system database."

  def assert(&block)
    raise AssertionError unless yield
  end

  def create_auth_item(options={})
    name_map = {operation: "oper_", task: "task_", role: ""}

    options.assert_valid_keys(:type, :name, :description, :bizrule, :data)
    assert { options[:name] && options[:name].strip != "" }
    options[:type] ||= "operation"
    type = options.delete(:type)
    type = type.sym if type.is_a?(String)
    name = options.delete(:name)
    name = "#{name_map[type]}#{name.strip}"

    auth_item = AuthItem.where(name: name).first
    unless auth_item
      Erbac.send("create_#{type}", name, options)
    else
      auth_item.update_attributes!(options)
      auth_item
    end
  end

  def add_child(parent, child)
    begin
      parent.add_child child
    rescue ActiveRecord::RecordNotUnique => e
      true
    end
  end

  task :import => :environment do
    puts "creating..."

    # Conversations
    # Conversations operations
    oper_conversations_show = create_auth_item type: :operation, name: 'conversations_show', description: 'Read a conversation'
    oper_conversations_destroy = create_auth_item type: :operation, name: 'conversations_destroy', description: 'Delete a conversation'
    # Conversations tasks
    task_own_conversation = create_auth_item type: :task, name: 'own_conversation', description: 'Manage a conversation by talkers', bizrule: 'self.id == params[:conversation].first_account_id || self.id == params[:conversation].second_account_id'
    add_child task_own_conversation, oper_conversations_show
    add_child task_own_conversation, oper_conversations_destroy

    # Comments
    # Comments operations
    oper_comments_destroy = create_auth_item type: :operation, name: 'comments_destroy', description: 'Delete a comment'
    # Comments tasks
    task_own_comment = create_auth_item type: :task, name: 'own_comment', description: 'Manage a comment by author himself or the post author', bizrule: 'self.id == params[:comment].author_id || self.id == params[:comment].post_author_id'
    add_child task_own_comment, oper_comments_destroy

    # Groups
    # Groups operations
    oper_groups_create = create_auth_item type: :operation, name: 'groups_create', description: 'Create a group'
    oper_groups_update = create_auth_item type: :operation, name: 'groups_update', description: 'Update a group'
    oper_groups_destroy = create_auth_item type: :operation, name: 'groups_destroy', description: 'Delete a group'
    # Groups tasks
    task_own_group = create_auth_item type: :task, name: 'own_group', description: 'Manage a group by author himself', bizrule: 'self.id == params[:group].creator_id'
    add_child task_own_group, oper_groups_update
    add_child task_own_group, oper_groups_destroy

    # Posts
    # Posts operations
    oper_posts_destroy = create_auth_item type: :operation, name: 'posts_destroy', description: 'Delete a post'
    # Posts tasks
    task_own_post = create_auth_item type: :task, name: 'own_post', description: 'Manage a post by author himself', bizrule: 'self.id == params[:post].account_id'
    add_child task_own_post, oper_posts_destroy

    # PrivateMessages
    # privateMessages operations
    oper_private_messages_destroy = create_auth_item type: :operation, name: 'private_messages_destroy', description: 'Delete a private message'
    # privateMessages tasks
    task_own_private_message = create_auth_item type: :task, name: 'own_private_message', description: 'Manage a private message by talkers', bizrule: 'self.id == params[:private_message].conversation.first_account_id || self.id == params[:private_message].conversation.second_account_id'
    add_child task_own_private_message, oper_private_messages_destroy

    # Subjects
    # Subjects operations
    #oper_subjects_create = Erbac.create_operation 'oper_subjects_create', description: 'Create a subject'
    oper_subjects_update = create_auth_item type: :operation, name: 'subjects_update', description: 'Update a subject'
    # Subjects tasks
    task_own_subject = create_auth_item type: :task, name: 'own_subject', description: 'Manage a subject by author himself', bizrule: 'self.id == params[:subject].account_id'
    add_child task_own_subject, oper_subjects_update

    # Tags
    # Tags operations
    oper_tags_create = create_auth_item type: :operation, name: 'tags_create', description: 'Create a tag'
    oper_tags_destroy = create_auth_item type: :operation, name: 'tags_destroy', description: 'Destroy a tag'

    # Roles
    common_user = create_auth_item type: :role, name: "common_user"
    add_child common_user, task_own_conversation
    add_child common_user, task_own_comment
    add_child common_user, task_own_group
    add_child common_user, task_own_post
    add_child common_user, task_own_private_message
    add_child common_user, task_own_subject

    admin = create_auth_item type: :role, name: "admin"
    add_child admin, oper_comments_destroy
    add_child admin, oper_groups_create
    add_child admin, oper_groups_destroy
    add_child admin, oper_posts_destroy
    add_child admin, oper_tags_create
    add_child admin, oper_tags_destroy
  end

  task :clean => :environment do
    puts "cleaning..."
    AuthItem.destroy_all
  end

  task :assign, [:auth_item_name, :item] => :environment do |t, args|
    puts "assign Account(##{args[:item]}) to #{args[:auth_item_name]}"
    auth_item = AuthItem.where(name: args[:auth_item_name]).first
    unless auth_item
      puts "can't find #{args[:auth_item_name]}"
      return
    end
    account = Account.find(args[:item].to_i)

    Erbac.assign auth_item, account
  end

  task :revoke, [:auth_item_name, :item] => :environment do |t, args|
    puts "revoke Account(##{args[:item]}) from #{args[:auth_item_name]}"
    auth_item = AuthItem.where(name: args[:auth_item_name]).first
    unless auth_item
      puts "can't find #{args[:auth_item_name]}"
      return
    end
    account = Account.find(args[:item].to_i)

    Erbac.revoke auth_item, account
  end
end
