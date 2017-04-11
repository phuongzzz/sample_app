class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_desc, -> {order created_at: :DESC}
  scope :feeds, -> id{where "user_id IN (SELECT followed_id FROM relationships
    WHERE follower_id = #{id}) OR user_id = #{id}"}
  mount_uploader :picture, PictureUploader
  validates :user, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.length}
  validate :picture_size

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, t("micropost.picture")
    end
  end
end
