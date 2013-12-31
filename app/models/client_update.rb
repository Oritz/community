class ClientUpdate < ActiveRecord::Base
  attr_accessible :full_pkg, :desc
  validates :full_pkg_file, :full_pkg_digest, :description, presence: true
  STATUS_RELEASED = 1
  STATUS_UNRELEASED = 0

  def patch
    ClientFile.new("#{self.major_ver}.#{self.minor_ver}.#{self.tiny_ver}", "patch_file")
  end

  def full_pkg
    ClientFile.new("#{self.major_ver}.#{self.minor_ver}.#{self.tiny_ver}", "full_pkg_file")
  end

  def full_pkg=(pkg)
    full_name = pkg.original_filename
    if full_name.index("_") && File.extname(full_name) == ".msi"
      full_pkg_name = full_name.split("_")[1]
      upload_full_pkg_ver = full_pkg_name.split(".")
      if valid_version?(upload_full_pkg_ver, latest_version)
        self.major_ver = upload_full_pkg_ver[0]
        self.minor_ver = upload_full_pkg_ver[1]
        self.tiny_ver = upload_full_pkg_ver[2]

        @full_name_number = get_version_number(full_name)
        full_pkg_file = ClientFile.new(@full_name_number,'full_pkg_file', pkg)
        full_pkg_file.save

        self.status =  ClientUpdate::STATUS_RELEASED
        self.full_pkg_file = full_pkg_file.client_path
        self.full_pkg_digest = full_pkg_file.client_digest

        @full_pkg = true
      else
        self.errors[:base] << I18n.t('admin.error.newer_version_exsit')
      end
    else
      self.errors[:base] << I18n.t('admin.error.client_name_format_error')
    end
  end

  def patch=(patch)
    patch_name = patch.original_filename
    patch_name_number = get_version_number(patch_name)
    if patch_name_number == @full_name_number
      patch_file = ClientFile.new(patch_name_number, "patch_file", patch)
      patch_file.save
    else
      self.errors[:base] << I18n.t('admin.error.full_pkg_and_patch_not_at_same_version')
    end
  end

  def desc=(desc)
    self.description = desc.read
  end


  def destroy
    super
    self.full_pkg.delete
    self.patch.delete if self.patch
  end

  before_save :do_validate

  private
  def latest_version
    lateset_client = self.class.select('major_ver, minor_ver, tiny_ver').order('id DESC').first
    latest_ver_number = lateset_client ? [lateset_client.major_ver, lateset_client.minor_ver, lateset_client.tiny_ver] : [0, 0, 0]
  end

  def valid_version?(upload_ver,lastest_ver)
    result = false
    (0..2).each do |i|
      if upload_ver[i].to_i > lastest_ver[i].to_i
        result = true
        break
      end
    end
    return result
  end

  def do_validate
    unless self.full_pkg && self.description
      self.errors[:base] << I18n.t('admin.error.field_missing')
    end
  end

  def get_version_number(client_name)
    return client_name.split(".ms")[0].split("_")[1]
  end

end
