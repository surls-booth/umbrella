p "Where are you located?"

# user_location = gets.chomp

user_location = "chicago Booth harper Center"

gmaps_token = ENV.fetch("GMAPS_KEY")
pirate_token = ENV.fetch("PIRATE_WEATHER_KEY")

p user_location

gmaps_api_endpoint = ("https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_token}")

require "open-uri"

raw_response = URI.open(gmaps_api_endpoint).read

require "json"

parsed_response = JSON.parse(raw_response)

# p parsed_response.keys

results_array = parsed_response.fetch("results")

first_result = results_array.at(0)

geo = first_result.fetch("geometry")

loc = geo.fetch("location")

latitude = loc.fetch("lat")
longitude = loc.fetch("lng")

# p latitude
# p longitude

## Lab
# Pirate_weather API - Get the weather at the user's coordinates from the Pirate Weather API.

pirate_api_endpoint = ("https://api.pirateweather.net/forecast/#{pirate_token}/#{latitude},#{longitude}")

pirate_raw = URI.open(pirate_api_endpoint).read

parsed_pirate_weather_data = JSON.parse(pirate_raw)

# p parsed_pirate_weather_data.keys

current_weather = parsed_pirate_weather_data.fetch("currently")

# p current_weather # print the all of the weather data under "currently"

##  Display the current temperature and summary of the weather for the next hour. ##

# pirate_temp = current_weather.fetch("temperature") # this is the same thing as line 54, this is the non shortcut way

pirate_temp = current_weather["temperature"]
pirate_summary = current_weather["summary"]

p pirate_temp
p pirate_summary

## For each of the next twelve hours, check if the precipitation probability is greater than 10%. ##
