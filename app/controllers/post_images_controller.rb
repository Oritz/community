class PostImagesController < ApplicationController
  before_filter :sonkwo_authenticate_account

  def create
    subject = Subject.find(params[:subject_id])
    cloud_storage = CloudStorage.find(params[:cloud_storage_id])

    post_image = PostImage.new(params[:post_image])
    post_image.post = subject.post
    post_image.cloud_storage = cloud_storage

    respond_to do |format|
      if post_image.save
        format.html
        format.json { render json: { status: "success", data: { url: post_image.url } } }
      else
        format.html
        foramt.json { render json: { status: "fail", data: post_image.errors } }
      end
    end
  end
end
