class TextContent < Content

  def to_response
    {
      id: id,
      type: type,
      caption: caption
    }
  end
end
