require 'spec_helper'

discribe "Login", :type => :feature do
  context "when login without cookies" do

    before :each do 
      @account = FactoryGirl.create(:account)
    end

    it "should redirect to the root page via login page" do
      visit new_account_session_path
      page.should have_content I18n.t("email")
      page.should have_content I18n.t("password")
      page.should have_content I18n.t("submit")

      fill_in "email", with: @account.email
      fill_in "password", with: @account.password

      click_link "Sign in"

      response.should redirect_to root_path
      page.should have_content @account.email
    end

    it "should redirect to the previous page via other pages" do
      visit groups_path
      response.should redirect_to new_account_session_path
      page.should have_content I18n.t("email")
      page.should have_content I18n.t("password")
      page.should have_content I18n.t("submit")

      fill_in "email", with: @account.email
      fill_in "password", with: @account.password

      click_link "Sign in"

      response.should redirect_to groups_path
      page.should have_content @account.email

    end

    it "should display error message when failed less than 3 times and show the verify code when more than 3times" do
      visit groups_path

      fill_in "email", with: @account.email
      fill_in "password", with: "wrong_password"
      click_link "Sign in"

      page.should have_content I18n.t("devise.failure.invalid")
      
      fill_in "password", with: "wrong_password"
      click_link "Sign in"

      page.should have_content I18n.t("devise.failure.invalid")

      fill_in "password", with: "wrong_password"
      click_link "Sign in"

      page.should have_content I18n.t("devise.failure.invalid")
      page.should hava_content I18n.t("verify_code")      

    end    

    it "should failed to login when email isnt confirmed" do
      visit new_account_session_path
      account = FactoryGirl.create(:account, confirmed_at: nil)
      fill_in "email", with: account.email
      fill_in "password", with: @account.password

      click_link "Sign in"

      page.should have_content I18n.t("devise.failure.unconfirmed")   
    end

    it "should auto login when last login checked the 'remember me'" do
      visit new_account_session_path
      fill_in "email", with @account.email
      fill_in "password", with: @account.password
      check "remember_me"
      click_link "Sign in"

      response.should redirect_to root_path    

      visit destroy_account_session_path

      visit new_account_session_path
      response.should redirect_to root_path
    end
  end

  context "when login with cookies" do
    #to do
  end
end
