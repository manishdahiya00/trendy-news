namespace :fetch_astrodata do
  require "net/http"
  require "uri"

  task fetch_yesterday: :environment do
    # Yesterday Astrology
    sign = Astrology.signs
    sign.each do |k,v|
      uri = URI("https://aztro.sameerkumar.website/?sign=#{k}&day=yesterday")
      response = Net::HTTP.post_form(uri,'q'=> 'ruby')
      puts response
      hash_response = JSON.parse(response.body)
      puts hash_response
      astrology = Astrology.create(description: hash_response['description'],compatibility: hash_response['compatibility'],color: hash_response['color'], lucky_number: hash_response['lucky_number'], lucky_time: hash_response['lucky_time'],date_range: hash_response['date_range'],current_date: Date.today - 1.day,mood: hash_response['mood'],
        sign: "#{k}")
    end
  end

  task fetch_today: :environment do
    # Today Astrology
    sign = Astrology.signs
    sign.each do |k,v|
      uri = URI("https://aztro.sameerkumar.website/?sign=#{k}&day=today")
      response = Net::HTTP.post_form(uri,'q'=> 'ruby')
      hash_response = JSON.parse(response.body)
      puts hash_response

      astrology = Astrology.create(description: hash_response['description'],compatibility: hash_response['compatibility'],color: hash_response['color'], lucky_number: hash_response['lucky_number'], lucky_time: hash_response['lucky_time'],date_range: hash_response['date_range'],current_date: "#{Date.today}",mood: hash_response['mood'],
        sign: "#{k}" )
    end
  end

  task fetch_tomorrow: :environment do
    # Tomorrow Astrology
    sign = Astrology.signs
    sign.each do |k,v|
      uri = URI("https://aztro.sameerkumar.website/?sign=#{k}&day=tomorrow")
      response = Net::HTTP.post_form(uri,'q'=> 'ruby')
      hash_response = JSON.parse(response.body)
      puts hash_response
      astrology = Astrology.create(description: hash_response['description'],compatibility: hash_response['compatibility'],color: hash_response['color'], lucky_number: hash_response['lucky_number'], lucky_time: hash_response['lucky_time'],date_range: hash_response['date_range'],current_date: Date.today + 1.day,mood: hash_response['mood'],
        sign: "#{k}")
    end
  end
end
