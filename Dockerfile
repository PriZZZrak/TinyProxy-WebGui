FROM debian:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
		tor \
		obfs4proxy \
		ca-certificates \
		tor-geoipdb \
		tinyproxy \
		python3 \
		python3-flask \
  		wget \
    && rm -rf /var/lib/apt/lists/*
RUN wget --no-check-certificate --content-disposition https://github.com/PriZZZrak/TinyProxy-WebGui/raw/main/start.sh
RUN chmod +x start.sh
CMD ./start.sh

	
