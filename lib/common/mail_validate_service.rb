# -*- encoding : utf-8 -*-
class MailValidateService
	
	def send_validation(account_id, url)
	
		err = nil
		secret_key = "a00d843638871db324d37a3f40365011"
		
		account = Account.find(
			:first,
			:select =>"accounts.id AS aid, login_name, nick_name, email",
			:joins =>"INNER JOIN sg_users ON accounts.id = sg_users.account_id",
			:conditions =>["accounts.id=?",account_id]
		)
		
		
		request_url = "http://#{url}/user_auth/validate_email?account_id=#{account.aid}&login_name=#{account.login_name}"
		
		begin
		
			SysMailer.verify_email(account.active_email, account.login_name, request_url).deliver

		rescue
			puts $!.inspect
			puts $!.backtrace
			err = $!.to_s
		end
		
	end
	
	
	def validate_email(account_id, account_login_name)

		account = Account.find(account_id)
		
		if account && account.login_name == account_login_name
		
			if account.email_verified == Account::EMAIL_VERIFIED
			
				msg = I18n.t("ERRORS.ERROR_EMAIL_ALREADY_VERIFIED")
			else
			
				account.email_verified = Account::EMAIL_VERIFIED
				account.save!
			
				msg = I18n.t("MSGS.MSG_VERIFY_EMAIL_SUCESS")
			end
		
		else
			msg = I18n.t("MSGS.ERROR_EMAIL_PARAMS_INVALID")
		end
				
		return msg
	end
	
end
