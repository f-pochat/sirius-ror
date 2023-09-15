class HomeController < ApplicationController
  def index
    zipcode = params[:zipcode]

    if zipcode.blank?
      handle_invalid_zipcode
    else
      fetch_weather_data(zipcode)
    end
  end

  private

    def handle_invalid_zipcode
      flash.now[:alert] = I18n.t('flash.alert.invalid_zip_code')
    end

    def fetch_weather_data(zipcode)
      current_weather_result = WeatherService.new(zipcode).current_weather
      weather_forecast_result = WeatherService.new(zipcode).weather_forecast

      return unless current_weather_result[:weather_data] && weather_forecast_result[:forecast_data]

      @current_weather = current_weather_result[:weather_data]
      @weather_forecast = weather_forecast_result[:forecast_data]
      @data_pulled_from_cache = current_weather_result[:cached] || weather_forecast_result[:cached]
    end
end
