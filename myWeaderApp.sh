#!/bin/bash

#read -p 'Please enter a city name: ' city


city="lod"

function getUsage() {
    echo -e "Usage: $0 city\n"
}

#city="$1"
#if [ -z "$city" ]; then
 #   getUsage
 #   exit 1
#fi

url="https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=fd36da754a23c689e29157cde00b2aa4"

response=$(curl -s "$url")
if [ "$(echo "$response" | jq '.cod')" != 200 ]; then
    echo "Error: City '${city}' not found or API request failed."
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

echo "The weather in ${city} is:"

temperature=$(getTemperature)
humidity=$(getHumidity)
wind_speed=$(getWindSpeed)

echo "  temperature: ${temperature}°C"
echo "  humidity: ${humidity}%"
echo "  wind speed: ${wind_speed} m/s"
