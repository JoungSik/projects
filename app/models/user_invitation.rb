class UserInvitation < ApplicationRecord
  belongs_to :inviter, foreign_key: :inviter_id, class_name: "User"
  belongs_to :invitee, foreign_key: :invitee_id, class_name: "User", optional: true

  validates :token, presence: true, uniqueness: true
  validates_presence_of :invitee_email

  enum :status, { pending: 0, accepted: 1, expired: 2, revoked: 3 }

  before_create :generate_token, :set_expiry

  def expired?
    expires_at.present? && expires_at < Time.zone.now
  end

  private

  def generate_token
    self.token ||= SecureRandom.hex(16)
  end

  def set_expiry
    self.expires_at ||= 7.days.from_now
  end
end
