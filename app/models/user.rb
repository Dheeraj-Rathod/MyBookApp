class User < ApplicationRecord
  has_secure_password

  has_many :books, dependent: :destroy

  before_validation :normalize_email

  validates :email, presence: true, uniqueness: true
  validates :email, format: {
    with: /\A[^@\s]+@[^@\s]+\z/
  }

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end