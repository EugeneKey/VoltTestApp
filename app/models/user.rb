class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "40x40>" }, default_url: "/images/:style/missing.png"
  validates_attachment :avatar,
    content_type: { content_type: ["image/jpeg", "image/png"] },
    size: { less_than: 3.megabytes }
  validates :nickname, presence: true
end
