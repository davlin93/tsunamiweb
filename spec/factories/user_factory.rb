FactoryGirl.define do
  factory :user do
    sequence :guid do |n|
      "123456-#{n}"
    end
  end
end
