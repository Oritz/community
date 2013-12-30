class Admin::AccountsController < AdminController
	def index
    @accounts = Account.includes(:auth_items).page(params[:page]).per(10)
	end

  def edit
    @roles = AuthItem.roles
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])
    new_role_ids = params[:account] ? params[:account][:roles] : []
    @account.roles = new_role_ids
    respond_to do |format|
      format.html { redirect_to edit_admin_account_path(@account), notice: t('admin.msg.success') }
      format.json { render json: @admin_auth_item.errors, status: :unprocessable_entity }
    end
  end
end
