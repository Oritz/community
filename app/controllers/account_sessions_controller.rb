class AccountSessionsController < Devise::SessionsController
  protect_from_forgery except: :create

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    sso_sign_in
    respond_to do |format|
      format.html { respond_with resource, :location => after_sign_in_path_for(resource) }
      format.json { render json: {status: 'success', data: {account_id: self.resource.id, nick_name: self.resource.nick_name, token: form_authenticity_token, avatar: self.resource.avatar}} }
    end
  end

  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?

    cookies.delete(:sso_auth, :domain => Settings.sso.root_domain)
    cookies.delete(:client, :domain => Settings.sso.root_domain)

    respond_to do |format|
      format.all { head :no_content }
      format.html do
        @destination = redirect_path
        render "devise/sessions/sso_signout", :layout => false
      end
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end

  protected
  def sso_sign_in
    # sso sign in
    params[:client] ||= "web"
    client = params[:client].strip.downcase
    now_time = Time.now.to_i
    sso_domain_key = Settings.sso.domain_key
    auth_token = Digest::SHA1.hexdigest("#{current_account.id},#{current_account.email},#{now_time},#{sso_domain_key}")
    if current_account.remember_expired?
      cookies[:sso_auth] = {
        :value => "#{current_account.id},#{auth_token},#{now_time},#{current_account.email}",
        :domain => Settings.sso.root_domain
      }
    else
      cookies[:sso_auth] = {
        :value => "#{current_account.id},#{auth_token},#{now_time},#{current_account.email}",
        :domain => Settings.sso.root_domain,
        :expires => current_account.remember_expires_at
      }
    end
    cookies[:client] = {
      :value => client,
      :domain => Settings.sso.root_domain
    }
  end
end
