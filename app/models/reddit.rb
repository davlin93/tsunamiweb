require 'net/http'

module Reddit
  def self.getShowerThoughts(count)
    url = URI.parse('http://www.reddit.com/r/showerthoughts/top.json?t=day&limit=' + count.to_s)
    puts url
    request = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(url.host, url.port) { |http|
      http.request(request)
    }

    body = JSON.parse(response.body).with_indifferent_access

    if response.code == '200'
      titles = Array.new
      body[:data][:children].first(count).each do |post|
        titles.push(post[:data][:title])
      end

      return titles
    else
      return 'error'
    end
  end
end