#!/bin/bash

HOST_IP=$(python3 -c "import socket; print(socket.gethostbyname(socket.gethostname()))")
echo "Detected host IP: $HOST_IP"

if [ "$1" = "install-phone" ]; then
    make install-phone HOST_IP=$HOST_IP
else
    exec "$@"
fi