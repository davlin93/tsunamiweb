FactoryGirl.define do
  factory :wave do
    after(:create) do |wave|
      FactoryGirl.create(:content, wave: wave)
    end
  end
end