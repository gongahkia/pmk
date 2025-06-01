FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    python3 \
    nodejs \
    npm \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q -O - https://assets.getpebble.com/pebble-toolchain-latest.sh | bash
RUN pebble sdk install https://github.com/pebble/dev-ubuntu-vm/raw/master/sdk3/pebble-sdk-4.5-linux64.tar.bz2

RUN npm install -g pebble-cli

WORKDIR /pebble-app

COPY package*.json ./
COPY ./lib/inject-env.js ./lib/
RUN npm install xmlhttprequest crypto-js

COPY . .

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["make", "build"]