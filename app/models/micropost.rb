class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_desc, -> {order created_at: :DESC}

  mount_uploader :picture, PictureUploader
  validates :user, presence: true
  validates :content, presence: true
    length: {maximum: Settings.micropost.length}
  validate :picture_size

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, t("micropost.picture")
    end
  end
end
