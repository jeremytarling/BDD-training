Feature: 3 day forecast

test that the Weather REST API produces a JSON feed of the three day forecast for a specified location, variable by language and location

	Scenario: the 3-day forecast feed returns data for three days
		When I request the three day forecast with "en" as language and 2655985 as location code
		Then I should get 200 as response code
		And the response body JSON should contain 3 forecasts
		And each forecast should have a date

	Scenario: the 3-day forecast feed with invalid location code returns 404
		When I request the three day forecast with "en" as language and 0000000 as location code
		Then I should get 404 as response code
		
	Scenario: the 3-day forecast feed with invalid language returns 400
		When I request the three day forecast with "zz" as language and 2655985 as location code
		Then I should get 400 as response code
			
