#!/bin/bash

#read -p 'Please enter a CITY name: ' CITY
#read -p 'Please enter an API KEY: ' API_KEY

function getUsage() {
    echo -e "Usage: $0 CITY\n"
}


if [[ -z "$API_KEY" ]]; then
  echo "API_KEY is not set. Exiting."
  exit 1
fi


if [[ -z "$CITY" ]]; then
  echo "CITY is not set. Using default value: 'London'."
  CITY="London"
fi

url="https://api.openweathermap.org/data/2.5/weather?q=$CITY&units=metric&appid=$API_KEY"

response=$(curl -s "$url")
if [ "$(echo "$response" | jq '.cod')" != 200 ]; then
    echo "Error: City '${CITY}' not found or API request failed."
    exit 1
fi


function getTemperature() {
    curl -s "$url" | jq ".main.temp"
}
function getHumidity() {
    curl -s "$url" | jq ".main.humidity"
}

function getWindSpeed() {
    curl -s "$url" | jq ".wind.speed"
}

echo "The weather in ${CITY} is:"

temperature=$(getTemperature)
humidity=$(getHumidity)
wind_speed=$(getWindSpeed)

echo "  temperature: ${temperature}°C"
echo "  humidity: ${humidity}%"
echo "  wind speed: ${wind_speed} m/s"
