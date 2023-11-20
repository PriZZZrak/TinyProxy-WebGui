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
RUN cd /etc/tinyproxy
RUN mkkdir web
RUN wget --no-check-certificate --content-disposition https://github.com/PriZZZrak/TinyProxy-WebGui/raw/main/webapp/app.py
RUN mkdir templates
RUN cd templates
RUN wget --no-check-certificate --content-disposition https://github.com/PriZZZrak/TinyProxy-WebGui/raw/main/webapp/templates/index.html
RUN wget --no-check-certificate --content-disposition https://github.com/PriZZZrak/TinyProxy-WebGui/raw/main/webapp/templates/site_list.html
RUN chmod +x start.sh
CMD ./start.sh

	
