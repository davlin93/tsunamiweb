class Content < ActiveRecord::Base
  attr_accessible :id, :title, :body, :content_type

  belongs_to :wave

  def to_response
    {
      id: id,
      content_type: content_type,
      title: title,
      body: body
    }
  end
end
