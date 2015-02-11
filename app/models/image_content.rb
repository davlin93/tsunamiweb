class ImageContent < Content

  def to_response
    {
      id: id,
      type: type,
      link: link,
      caption: caption
    }
  end
end
