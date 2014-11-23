FactoryGirl.define do
  factory :user do
    name 'David'
    sequence :guid do |n|
      "123456-#{n}"
    end
  end
end
