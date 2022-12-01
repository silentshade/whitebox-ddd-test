Capybara.register_driver :custom_selenium_chrome_headless do |app|
  version = Capybara::Selenium::Driver.load_selenium
  options_key = Capybara::Selenium::Driver::CAPS_VERSION.satisfied_by?(version) ? :capabilities : :options
  browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument('--headless') unless ENV['UI']
    opts.add_argument('--disable-gpu') if Gem.win_platform?
    # Workaround https://bugs.chromium.org/p/chromedriver/issues/detail?id=2650&q=load&sort=-id&colspec=ID%20Status%20Pri%20Owner%20Summary
    opts.add_argument('--disable-site-isolation-trials')
  end

  Capybara::Selenium::Driver.new(app, **{ :browser => :chrome, options_key => browser_options })
end

Capybara.configure do |config|
  config.javascript_driver = :custom_selenium_chrome_headless
  config.app_host = 'http://localhost:4000'
  config.server_host = 'localhost'
  config.server_port = '4000'
end

RSpec.configure do |config|
  config.include ActionView::RecordIdentifier, type: :feature
end
