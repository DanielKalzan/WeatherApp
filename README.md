# Weather Info Script

This Bash script fetches and displays the current weather information for a specified city using the OpenWeatherMap API.

## Prerequisites

- `curl` must be installed on your system.
- `jq` must be installed on your system.
- An API key from OpenWeatherMap.

## Setup

1. Install `curl` and `jq` if they are not already installed:

    ```bash
    sudo apt-get install curl jq
    ```

2. Obtain an API key from [OpenWeatherMap](https://home.openweathermap.org/users/sign_up).

3. Replace the placeholder API key in the script with your actual API key:

    ```bash
    url="https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=YOUR_API_KEY"
    ```

## Usage

### Default City

By default, the script is set to fetch the weather information for the city of Lod. To run the script, simply execute:

```bash
./weather_info.sh
```

### User enters the name of a city

To fetch the weather information for a specific city, run the script and enter the city name when prompted or pass the city name as an argument:

1. **Run the script and enter the city name when prompted**:

    ```bash
    ./weather_info.sh
    ```

    When prompted, enter the city name:

    ```bash
    Please enter a city name: Tel Aviv
    ```

2. **Pass the city name as an argument**:

    ```bash
    ./weather_info.sh Tel Aviv
    ```

## Script Explanation

The script performs the following tasks:

1. **Prompt for city input or accept as an argument**:

    ```bash
    read -p 'Please enter a city name: ' city
    city="$1"
    if [ -z "$city" ]; then
        getUsage
        exit 1
    fi
    ```

2. **Get usage function**: Displays the correct usage of the script.

    ```bash
    function getUsage() {
        echo -e "Usage: $0 city\n"
    }
    ```

3. **Form the API request URL**: 

    ```bash
    url="https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=YOUR_API_KEY"
    ```

4. **Fetch and validate the response**: Uses `curl` to fetch the weather data and `jq` to parse and validate the response.

    ```bash
    response=$(curl -s "$url")
    if [ "$(echo "$response" | jq '.cod')" != 200 ]; then
        echo "Error: City '${city}' not found or API request failed."
        exit 1
    fi
    ```

5. **Functions to get weather details**:

    ```bash
    function getTemperature() {
        curl -s "$url" | jq ".main.temp"
    }
    function getHumidity() {
        curl -s "$url" | jq ".main.humidity"
    }
    function getWindSpeed() {
        curl -s "$url" | jq ".wind.speed"
    }
    ```

6. **Display the weather information**:

    ```bash
    echo "The weather in ${city} is:"

    temperature=$(getTemperature)
    humidity=$(getHumidity)
    wind_speed=$(getWindSpeed)

    echo "  temperature: ${temperature}°C"
    echo "  humidity: ${humidity}%"
    echo "  wind speed: ${wind_speed} m/s"
    ```

## Role of jq Library

The `jq` library is a powerful tool for processing JSON data in the command line. In this script, `jq` is used to parse and extract specific fields from the JSON response returned by the OpenWeatherMap API. Here is how `jq` is used in the script:

1. **Validate the API response**: Check if the response code is `200` (successful response).

    ```bash
    if [ "$(echo "$response" | jq '.cod')" != 200 ]; then
        echo "Error: City '${city}' not found or API request failed."
        exit 1
    fi
    ```

2. **Extract weather details**: Extract the temperature, humidity, and wind speed from the JSON response.

    ```bash
    function getTemperature() {
        curl -s "$url" | jq ".main.temp"
    }
    function getHumidity() {
        curl -s "$url" | jq ".main.humidity"
    }
    function getWindSpeed() {
        curl -s "$url" | jq ".wind.speed"
    }
    ```

In summary, `jq` helps to filter and format the JSON data in a way that makes it easy to extract and display the specific information needed from the API response.

## Example

Here is an example output of the script when fetching the weather information for Tel Aviv:

```bash
Please enter a city name: Tel Aviv
The weather in Tel Aviv is:
  temperature: 28°C
  humidity: 60%
  wind speed: 3.6 m/s
