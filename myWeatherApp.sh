#!/usr/bin/env bash

# Usage: ./myWeatherApp.sh [CITY] [API_KEY]
# Env vars API_KEY and CITY are also supported (used by Docker/CI).

# --- Input resolution: positional args override env vars ---
API_KEY="${2:-$API_KEY}"
CITY="${1:-$CITY}"
x=25
# --- Validate required inputs ---
if [[ -z "$API_KEY" ]]; then
  echo "Error: API_KEY is not set. Pass it as the 2nd argument or set the API_KEY env var."
  exit 1
fi

if [[ -z "$CITY" ]]; then
  echo "CITY is not set. Using default value: 'London'."
  CITY="London"
fi

# --- Fetch weather data ---
URL="https://api.openweathermap.org/data/2.5/weather?q=${CITY}&units=metric&appid=${API_KEY}"
RESPONSE=$(curl -s "$URL")

# Fix: .cod returns a string "200" in some API versions — strip quotes with -r
COD=$(echo "$RESPONSE" | jq -r '.cod')
if [[ "$COD" != "200" ]]; then
  echo "Error: City '${CITY}' not found or API request failed. (cod: ${COD})"
  exit 1
fi

# --- Parse fields from the single response (no extra curl calls) ---
TEMPERATURE=$(echo "$RESPONSE" | jq -r '.main.temp')
HUMIDITY=$(echo "$RESPONSE"    | jq -r '.main.humidity')
WIND_SPEED=$(echo "$RESPONSE"  | jq -r '.wind.speed')

# --- Display results ---
echo "The weather in ${CITY} is:"
echo "  Temperature : ${TEMPERATURE}°C"
echo "  Humidity    : ${HUMIDITY}%"
echo "  Wind speed  : ${WIND_SPEED} m/s"
