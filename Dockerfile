FROM eclipse-temurin:25-jdk

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget unzip ca-certificates curl jq && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1001 hytale && \
    useradd -u 1001 -g 1001 -d /hytale-server hytale

RUN mkdir -p /hytale-server && \
	chown -R 5520:5520 /hytale-server

WORKDIR /hytale-server

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
