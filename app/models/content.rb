class Content < ActiveRecord::Base
  attr_accessible :id, :caption, :link, :type

  belongs_to :wave
end
