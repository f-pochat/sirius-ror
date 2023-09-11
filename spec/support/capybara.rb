# frozen_string_literal: true

Capybara.register_driver :headless_chromium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options:
  )
end
Capybara.javascript_driver = :headless_chromium
