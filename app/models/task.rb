class Task < ApplicationRecord
  # Using type column
  self.inheritance_column = nil

  has_rich_text :description

  belongs_to :project
  belongs_to :assign_user, foreign_key: :assign_user_id, class_name: "User"
  belongs_to :creator, foreign_key: :creator_id, class_name: "User"

  validates_presence_of :title

  enum :type, { planning: 0, feature: 1, issue: 2 }, default: :feature
  enum :priority, { critical: 0, high: 1, medium: 2, low: 3, trivial: 4 }, default: :trivial
  enum :status, { not_started: 0, in_progress: 1, overdue: 2, completed: 3, cancelled: 4, archived: 5 }, default: :not_started

  TYPE_DEFAULT = types[:feature]
  PRIORITY_DEFAULT = priorities[:trivial]
  STATUS_DEFAULT = statuses[:not_started]

  before_validation :set_end_at_if_blank, :mark_as_overdue_if_needed

  scope :ongoing, -> { where(status: [ :not_started, :in_progress, :overdue ]) }

  def self.visible_statuses
    statuses.except(:archived)
  end

  private

  def set_end_at_if_blank
    self.end_at ||= self.start_at
  end

  def mark_as_overdue_if_needed
    overdue! if not_started? && self.end_at < Time.zone.today
  end
end
