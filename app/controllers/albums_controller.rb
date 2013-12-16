class AlbumsController < ApplicationController
  layout 'center'

  def index
    @account = Account.find(params[:user_id])
    @albums = @account.albums.where(status: Album::STATUS_NORMAL).paginate(page: params[:page], per_page: 10)
  end

  def create
  end

  def show
  end

  def new
  end
end
