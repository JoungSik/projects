class Project < ApplicationRecord
  belongs_to :workspace
  belongs_to :owner, foreign_key: :owner_id, class_name: "User"
  belongs_to :creator, foreign_key: :creator_id, class_name: "User"
  
  has_many :tasks, dependent: :destroy

  validates_presence_of :title
end
