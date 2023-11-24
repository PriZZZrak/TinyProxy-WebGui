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
ADD https://github.com/PriZZZrak/TinyProxy-WebGui/raw/main/start.sh ./
RUN chmod +x start.sh
ADD https://github.com/PriZZZrak/TinyProxy-WebGui/raw/main/webapp/app.py /web/
ADD https://github.com/PriZZZrak/TinyProxy-WebGui/raw/main/webapp/templates/index.html /web/templates/
ADD https://github.com/PriZZZrak/TinyProxy-WebGui/raw/main/webapp/templates/site_list.html /web/templates/
ADD https://github.com/PriZZZrak/TinyProxy-WebGui/raw/main/config/torrc.base /config/
ADD https://github.com/PriZZZrak/TinyProxy-WebGui/raw/main/config/tinyproxy.base /config/
CMD ./start.sh

	
