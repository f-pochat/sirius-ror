require 'redis'

class WeatherService
  include HTTParty
  base_uri 'https://api.openweathermap.org/data/2.5'
  @redis = Redis.new(host: 'localhost', port: 6379, db: 11)

  def initialize(zipcode)
    @zipcode = zipcode
  end

  def fetch_data(url, cache_key)
    response = self.class.get(url)
    if response.success?
      self.class.redis.set(cache_key, response.body, ex: 1800) # Expires in 30 minutes
      response = JSON.parse(response.body)
    else
      response = nil # Handle the API request failure gracefully
    end
    response
  end

  def current_weather
    cached_data = self.class.redis.get("current_weather_#{@zipcode}")
    if cached_data
      response = JSON.parse(cached_data)
      cached = true
    else
      response = fetch_data("/weather?zip=#{@zipcode}&appid=#{ENV.fetch('OPENWEATHER_API_KEY', nil)}&units=metric",
                            "current_weather_#{@zipcode}")
      cached = false
    end
    { weather_data: response, cached: } # Return a hash with weather data and cache flag
  end

  def weather_forecast
    cached_data = self.class.redis.get("weather_forecast_#{@zipcode}")
    if cached_data
      response = JSON.parse(cached_data)
      cached = true
    else
      response = fetch_data("/forecast?zip=#{@zipcode}&appid=#{ENV.fetch('OPENWEATHER_API_KEY', nil)}&units=metric",
                            "weather_forecast_#{@zipcode}")
      cached = false
    end
    { forecast_data: response, cached: } # Return a hash with forecast data and cache flag
  end

  class << self
    attr_reader :redis
  end
end
