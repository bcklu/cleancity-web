class Image < ActiveRecord::Base
  belongs_to :incident_report

  has_attached_file :image
end
