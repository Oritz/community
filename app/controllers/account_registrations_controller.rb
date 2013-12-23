class AccountRegistrationsController < Devise::RegistrationsController
  layout 'center', only: :edit

  def update
  end
end
