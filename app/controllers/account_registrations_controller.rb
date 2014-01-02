class AccountRegistrationsController < Devise::RegistrationsController
  layout 'center', only: [:edit, :update]
  def new
    @show_register = false
    super
  end
end
