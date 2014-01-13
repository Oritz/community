class AdminController < ApplicationController
  before_filter :sonkwo_authenticate_account
  before_filter {|controller| controller.check_access?({:auth_item => 'oper_admin'})}
  def index
  end
end