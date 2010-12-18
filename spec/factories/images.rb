# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :image do |f|
  f.image_content_type "MyString"
  f.image_file_size 1
  f.image_file_name "MyString"
end
