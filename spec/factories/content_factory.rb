FactoryGirl.define do
  factory :content do
    sequence :title do |n|
      "Title #{n}"
    end
    sequence :body do |n|
      "Body #{n}"
    end
  end
end