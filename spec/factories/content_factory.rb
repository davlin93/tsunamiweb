FactoryGirl.define do
  factory :content do
    sequence :caption do |n|
      "caption #{n}"
    end
  end
end