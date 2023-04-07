p "Where are you located?"

# user_location = gets.chomp

user_location = "Chicago Booth Harper Center"

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

puts "Your coordinates are #{latitude}, #{longitude}."

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

pirate_temp = current_weather["temperature"] #temperature's class is "Float"
pirate_summary = current_weather["summary"]

puts "it is currently #{pirate_temp}°F and #{pirate_summary}."

## For each of the next twelve hours, check if the precipitation probability is greater than 10%. ##

# I'll need to look at the first 12 hours, so maybe use .times or something. I'll then print the "precipProbability" field's value.

hourly_hash = parsed_pirate_weather_data["hourly"] # hourly_hash is a Hash

hourly_data_array = hourly_hash["data"] # hourly_data_array is an Array. So, 2 lines above, I've taken a Hash and did I convert it into an array? hourly_data_array is ALL of the data under Hourly (a lot)

next_twelve_hours = hourly_data_array[1..12] #next_twelve_hours is an Array. To retrieve a single element from an Array I can use .at(). For a range of elements, I can use []

# puts next_twelve_hours # this prints everything under the "data" section for the next 12 rows (or hours)


precip_prob_threshold = 0.10

any_precipitation = false

next_twelve_hours.each do |hour_hash| #hour_hash is a block variable I'm making up
  precip_prob = hour_hash["precipProbability"] # here I'm fetching Precip probablity from the pirate API and assigning that value to my new variable "precip_prob"
  if precip_prob > precip_prob_threshold #if the precip_prob is greater than 0.10...
    any_precipitation = true

    precip_time = Time.at(hour_hash.fetch("time")) #here I'm creating a new variable called precip_time. I'm making it equal to the time at my new Block Variable fetching "time" from the api.
    seconds_from_now  = precip_time = Time.now # I don't know what Time.now is. Or "Time"

    hours_from_now = seconds_from_now / 60 / 60

    puts "in #{hours_from_now.round} hours, there is a #{(precip_prob * 100).round}% chance of precipitation "
  end
end

if any_precipitation == true
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella."
end
