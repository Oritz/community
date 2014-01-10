namespace :admin do
  desc "create a administrator and assign it to somebody"
  task :create, [:account] => ['environment', 'db:migrate'] do |t, args|
    begin
      raise 'Rake Failed, =========================pelease pass a email, like: rake admin:create[example@examle.com]' unless args && args.account
      administrator = AuthItem.roles.first
      account = Account.where('email =?', args.account).first
      raise 'Rake Failed, =========================error:there have already exist some role before administrator' if administrator
      raise 'Rake Failed, ========================error: can not find any account named #{args.account}' unless account
      ActiveRecord::Base.transaction do
        administrator = AuthItem.create!(:name =>'administrator', :auth_type => AuthItem::TYPE_ROLE, :description => 'root administrator')
        administrator.assign account
        puts 'Create Administrator success!'
        puts 'Initing basic items...'
      end

      operates = Settings.rights.basic_items
      operates.each do |k, v|
        role = AuthItem.create!(:name => k.to_s, :auth_type => AuthItem::TYPE_ROLE, :description => k.to_s)
        oper = AuthItem.create!(:name => v, :auth_type => AuthItem::TYPE_OPERATION, :description => v)
        role.add_child oper
        administrator.add_child role
        puts "Create #{k.to_s} success."
      end
      
      puts '-------------Complete!-------------------'
    rescue Exception => e
      puts e
    end
  end
end