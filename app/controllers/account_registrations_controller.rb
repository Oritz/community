class AccountRegistrationsController < Devise::RegistrationsController
  layout 'center', only: [:edit, :update]
  def new
    @show_register = false
    super
  end

  def edit
    qiniu_prepare(Settings.cloud_storage.avatar_bucket, "updateavatar")
    super
  end
end
