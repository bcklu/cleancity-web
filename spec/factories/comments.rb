# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :comment do |f|
  f.body "MyString"
  f.incident_report nil
  f.author nil
end
