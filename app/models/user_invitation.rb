class UserInvitation < ApplicationRecord
  belongs_to :inviter, foreign_key: :inviter_id, class_name: "User"
  belongs_to :invitee, foreign_key: :invitee_id, class_name: "User", optional: true

  validates :token, presence: true, uniqueness: true
  validates :invitee_email, presence: true, uniqueness: true

  enum :status, { pending: 0, accepted: 1, expired: 2 }, default: :pending

  validate :invitee_email_not_already_registered, on: :create

  before_validation :set_invited_at_if_blank, :set_expiry, on: :create
  before_validation :generate_token, unless: :accepted?

  after_commit :send_invite_email

  EXPIRY = 7.days

  def expired?
    pending? && expires_at.present? && expires_at < Time.zone.now
  end

  private

  def invitee_email_not_already_registered
    if User.exists?(email: self.invitee_email)
      errors.add(:base, :email_un_invitable)
    end
  end

  def generate_token
    self.token = SecureRandom.hex(16)
  end

  def set_invited_at_if_blank
    self.invited_at ||= Time.zone.now
  end

  def set_expiry
    self.expires_at ||= EXPIRY.from_now
  end

  def send_invite_email
    InvitationMailer.invite(self).deliver_now if pending?
  end
end
