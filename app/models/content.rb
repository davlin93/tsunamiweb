class Content < ActiveRecord::Base
  attr_accessible :id, :title, :body

  belongs_to :wave
end
