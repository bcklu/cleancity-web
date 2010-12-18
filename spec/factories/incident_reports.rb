# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :incident_report do |f|
  f.latitude 1.5
  f.longitude 1.5
  f.description "MyString"
  f.image ""
  f.author ""
end
