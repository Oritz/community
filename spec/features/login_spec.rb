require 'spec_helper'

feature "Login" do
  context "without cookies" do
    scenario "via login page" do
      account = FactoryGirl.create(:account)
      visit new_account_session_path

      fill_in "email", with: account.email
      fill_in "password", with: account.password

      click_link "Sign in"
      expect(response).to redirect_to(root_path)
    end
    scenario "via other pages"
    scenario "failed less than 3 times"
    scenario "failed more than 3 times"
    scenario "account isn't confirmed"
  end

  context "with cookies" do
    pending "to be done"
  end
end
