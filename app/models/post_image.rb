class PostImage < ActiveRecord::Base
  attr_accessible :comment

  # Associations
  belongs_to :post
  belongs_to :cloud_storage

  # Validations
  validates :post, presence: true
  validates :cloud_storage, presence: true
  validates :comment, length: { maximum: 30 }, if: Proc.new { |a| a.comment }

  # Methods
  def url
    cloud_storage.url
  end
end
