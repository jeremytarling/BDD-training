require 'json'
require 'restclient'

Before do
	@host = 'https://api.test.bbc.co.uk/'
	@url = 'weather/feeds/'
#	RestClient.proxy = "http://www-cache.reith.bbc.co.uk/"
	@ssl = {
		:ssl_client_cert => OpenSSL::X509::Certificate.new(File.read("/Users/tarlij01/Documents/BBC/certs/Forge.pem")),
		:ssl_client_key => OpenSSL::PKey::RSA.new(File.read("/Users/tarlij01/Documents/BBC/certs/Forge.pem"), "pppppp"),
	}
end

When /^I request the three day forecast with "(.*)" as language and (\d+) as location code$/ do |language, locationCode|
  url = @host + @url + language + '/' + locationCode + '/3dayforecast.json'
  puts "Requesting from #{url}"
  begin
    @response = RestClient::Resource.new(url, @ssl).get({:Cache_Control => "no-cache" })
  rescue => e
     @response = e.response
  end
end

Then /^I should get (\d+) as response code$/ do |expected_status|
  @response.code.to_s.should == expected_status
end

Then /^the response body JSON should contain (\d+) forecasts$/ do |number_of_forecasts|
  data = JSON.parse @response.body
  @forecasts = data['forecastContent']['forecasts']
  @forecasts.length.should == number_of_forecasts.to_i
end

Then /^each forecast should have a date$/ do
  @forecasts.each do |forecast|
    forecast['date'].should_not be_nil
  end
end
