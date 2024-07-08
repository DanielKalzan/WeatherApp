FROM debian:latest

COPY myWeatherApp.sh /

RUN apt-get update && apt-get install -y \
    bash \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*


CMD ["bash","/myWeatherApp.sh ${{API_KEY}}"]
