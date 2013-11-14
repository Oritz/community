class Api::ClientUpdatesController < ApplicationController
  def versions
    client_updates = ClientUpdate.sort_by_version(params[:major_ver].to_i, params[:minor_ver].to_i, params[:tiny_ver].to_i).select("major_ver, minor_ver, tiny_ver")
    render_for_api :version, json: client_updates, root: "data", meta: {status: "success"}
  end

  def latest_version
    client_update = ClientUpdate.latest_versions.select("major_ver, minor_ver, tiny_ver").first
    render_for_api :version, json: client_update, root: "data", meta: {status: "success"}
  end

  def patch
    client_update = get_client_update_from_version(select: "patch_file")
    return unless client_update

    if client_update.patch_file && client_update.patch_file.strip != "" 
      begin
        send_file client_update.patch_file
      rescue
        render json: { status: "error", message: I18n.t("ERRORS.ERROR_UNKNOW") }
      end
      return
    end
    
    render json: { status: "success", data: I18n.t("ERRORS.ERR_NO_FILE") }
  end

  def full_pkg
    client_update = get_client_update_from_version(select: "full_pkg_file")
    return unless client_update

    if client_update.full_pkg_file && client_update.full_pkg_file.strip != "" 
      begin
        send_file(client_update.full_pkg_file)
      rescue
        render json: { status: "error", message: I18n.t("ERRORS.ERROR_UNKNOW") }
      end
      return
    end
    
    render json: { status: "success", data: I18n.t("ERRORS.ERR_NO_FILE") }
  end

  def update_desc
    client_update = get_client_update_from_version(select: "description")
    return unless client_update

    send_data(client_update.description, :type => "application/zip", :stream=>'true', :filename => "client_description.txt" )
  end

  private
  def get_client_update_from_version(options={})
    options[:select] ||= "*"
    client_update = ClientUpdate.by_version(params[:major_ver].to_i, params[:minor_ver].to_i, params[:tiny_ver].to_i).select(options[:select]).first

    unless client_update
      render json: { status: "fail", data: I18n.t("ERRORS.ERR_CLIENT_NOT_FOUND") }
      return nil
    end

    client_update
  end
end
