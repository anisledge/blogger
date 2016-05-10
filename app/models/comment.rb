class Comment < ActiveRecord::Base
  validates :author_name, presence: true
  validates :body, presence: true, length: { maximum: 255 }
  belongs_to :article
end
