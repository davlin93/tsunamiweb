FactoryGirl.define do
  factory :user do
    sequence :guid do |n|
      "123456-#{n}"
    end
    after(:create) do |user|
      FactoryGirl.create(:social_profile, user: user)
    end
  end
end
