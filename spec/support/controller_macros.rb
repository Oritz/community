module ControllerMacros
  def login_account
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:account]
      account = FactoryGirl.create(:account)
      account.confirm!
      sign_in account
      controller.stub(current_account: account)
    end
  end

  def should_login(method, action, args={}, format="html")
    case format
    when "html"
      it "should redirect to login page" do
        send(method, action, args)
        expect(response).to redirect_to new_account_session
      end
    when "json"
      it "should return error message that identify 'need login'" do
        expect_json = {
          status: "fail",
          data: {
            code: 401,
            message: I18n.t("controllers.need_login")
          }
        }

        send(method, action, args)
        expect(response).body.to eq expect_json.to_json
      end
    end
  end
end
