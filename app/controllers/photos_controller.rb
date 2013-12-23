class PhotosController < ApplicationController
  before_filter :sonkwo_authenticate_account

  def index
  end

  def create
  end

  def screenshot
    screenshot_album = Album.screenshot_of_account(current_account).first
    unless screenshot_album
      ret = { status: "error", message: I18n.t("album.screenshot_not_exists") }
    else
      photo = Photo.new(params[:photo])
      photo.url = params[:photo][:url]
      photo.album = screenshot_album
      photo.account = current_account
      if photo.save
        ret = { status: "success", data: {id: photo.id} }
      else
        ret = { status: "fail", data: photo.errors }
      end
    end

    render json: ret
  end
end
