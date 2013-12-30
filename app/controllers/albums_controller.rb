class AlbumsController < ApplicationController
  layout 'center'

  def index
    @account = Account.find(params[:user_id])
    @albums = @account.albums.where(status: Album::STATUS_NORMAL).includes([cover:[:cloud_storage]]).page(params[:page]).per(10)
  end

  def create
  end

  def show
    @account = Account.find(params[:user_id])
    @album = Album.find(params[:id])
    not_found if @account != @album.account
    @photos = @album.photos.includes([photos: [:clode_storage]]).page(params[:page]).per(10)
  end

  def new
  end
end
