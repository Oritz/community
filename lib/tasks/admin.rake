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
        puts 'Success!'
      end
    rescue Exception => e
      puts e
    end
  end
end