FROM alpine:latest

COPY myWeatherApp.sh /

RUN apk add --no-cache \
    bash \
    curl \
    jq


CMD ["bash","/myWeatherApp.sh" ]
