class AccountRegistrationsController < Devise::RegistrationsController
  layout 'center', only: :edit
  def new
    @show_register = false
    super
  end

  def update
  end
end
