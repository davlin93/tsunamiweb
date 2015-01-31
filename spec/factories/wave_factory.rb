FactoryGirl.define do
  factory :wave do
    after(:create) do |wave|
      FactoryGirl.create(:content, wave: wave)
      u = FactoryGirl.create(:user)
      u.waves << wave
    end
  end
end