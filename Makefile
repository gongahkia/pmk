HOST_IP := $(shell python3 -c "import socket; print(socket.gethostbyname(socket.gethostname()))")

.PHONY: all install-deps build install-emulator install-phone clean

all: build

install-deps:
	@echo "Installing system dependencies..."
	sudo apt-get update && sudo apt-get install -y \
		wget \
		curl \
		nodejs \
		npm \
		python3

install-sdk: install-deps
	@echo "Installing Pebble SDK..."
	wget -q -O - https://assets.getpebble.com/pebble-toolchain-latest.sh | bash
	pebble sdk install https://github.com/pebble/dev-ubuntu-vm/raw/master/sdk3/pebble-sdk-4.5-linux64.tar.bz2

install-node-deps:
	@echo "Installing Node.js dependencies..."
	sudo npm install -g pebble-cli
	npm install xmlhttprequest crypto-js

build: install-sdk install-node-deps
	@echo "Building Pebble app..."
	pebble build

install-emulator: build
	@echo "Installing on emulator..."
	pebble install --emulator basalt

install-phone: build
	@echo "Installing on physical watch using host IP: $(HOST_IP)"
	pebble install --phone $(HOST_IP)

clean:
	@echo "Cleaning build artifacts..."
	pebble clean
	rm -f app/pebble-js-app.js