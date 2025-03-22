class UserInvitation < ApplicationRecord
  belongs_to :inviter, foreign_key: :inviter_id, class_name: "User"
  belongs_to :invitee, foreign_key: :invitee_id, class_name: "User", optional: true

  validates :token, presence: true, uniqueness: true
  validates_presence_of :invitee_email

  enum :status, { pending: 0, accepted: 1, expired: 2 }, default: :pending

  validate :invitee_email_not_already_registered, on: :create

  before_validation :generate_token, :set_invited_at_if_blank, :set_expiry, on: :create

  EXPIRY = 7.days

  # def expired?
  #   expires_at.present? && expires_at < Time.zone.now
  # end

  private

  def invitee_email_not_already_registered
    if User.exists?(email: self.invitee_email)
      errors.add(:base, :email_un_invitable)
    end
  end

  def generate_token
    self.token ||= SecureRandom.hex(16)
  end

  def set_invited_at_if_blank
    self.invited_at ||= Time.zone.now
  end

  def set_expiry
    self.expires_at ||= EXPIRY.from_now
  end
end
