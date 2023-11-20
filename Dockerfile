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
    && rm -rf /var/lib/apt/lists/*
COPY start.sh start.sh
RUN chmod +x start.sh
CMD ./start.sh

	
