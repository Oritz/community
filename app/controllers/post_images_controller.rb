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
        format.json { render json: { status: "success", data: { id: post_image.id, cloud_storage_id: cloud_storage.id, url: cloud_storage.url } } }
      else
        format.html
        foramt.json { render json: { status: "fail", data: post_image.errors } }
      end
    end
  end

  def destroy
    subject = Subject.find(params[:subject_id])
    post_image = PostImage.find(params[:id])

    if(post_image.post_id != subject.post.id)
      render json: { status: "error", message: I18n.t("subject.image_is_not_belongs_to") }
      return
    else
      respond_to do |format|
        if post_image.destroy
          format.html
          format.json { render json: { status: "success", data: { id: post_image.id } } }
        else
          format.html
          format.json { render json: {status: "fail", data: post_image.errors } }
        end
      end
    end
  end
end
