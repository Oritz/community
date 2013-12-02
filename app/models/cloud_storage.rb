class CloudStorage < ActiveRecord::Base
  attr_accessible :bucket_name, :key, :storage_type, :data, :private
  
  # Constants
  STORAGE_TYPE_VEDIO = 0
  STORAGE_TYPE_IMAGE = 1
  IS_PRIVATE = 0
  IS_PUBLIC = 1
  
  # Callbacks
  after_initialize :default_values
  
  # Associations
  belongs_to :account
  
  # Methods
  private
  def default_values
    self.storage_type ||= self.class::STORAGE_TYPE_IMAGE
    self.private ||= self.class::IS_PUBLIC
  end
end
