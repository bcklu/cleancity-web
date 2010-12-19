class Image < ActiveRecord::Base
  belongs_to :incident_report

  has_attached_file :image
  
  # I'm doing this after create as this assures that the image
  # was stored to the filesystem
  after_create :extract_location
  
  private
  
  def extract_location
    exif = EXIFR::JPEG.new(image.queued_for_write[:original].path)
    
    if exif && exif.gps_longitude && exif.gps_latitude && !exif.gps_longitude.empty? && !exif.gps_latitude.empty?
      longitude = exif.gps_longitude[0] + exif.gps_longitude[1]/60 + exif.gps_longitude[2]/3600
      latitude = exif.gps_latitude[0] + exif.gps_latitude[1]/60 + exif.gps_latitude[2]/3600
    
      if !incident_report.location_valid?
        incident_report.longitude = longitude
        incident_report.latitude = latitude
        incident_report.save!
      end
    end
  end
end
