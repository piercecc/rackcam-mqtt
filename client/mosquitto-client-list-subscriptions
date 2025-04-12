#!/bin/bash

# Script to discover all topics on a Mosquitto server
# Replace 'localhost' with your MQTT broker's address if needed

# Check if mosquitto_sub is installed
if ! command -v mosquitto_sub &> /dev/null; then
    echo "Error: mosquitto_sub is not installed. Please install Mosquitto tools."
    exit 1
fi
read -p "Enter Broker Address (default is localhost): " BROKER
read -p "Enter Port (default is 1883): " PORT
# Check if the broker address is valid
if ! [[ "$BROKER" =~ ^[a-zA-Z0-9._-]+(:[0-9]+)?$ ]]; then
    echo "Error: Invalid broker address format. Use 'hostname:port' or 'hostname'."
    exit 1
fi
# Check if the port is a valid number
if [[ "$PORT" =~ ^[0-9]+$ ]]; then
    if [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
        echo "Error: Port number must be between 1 and 65535."
        exit 1
    fi
else
    # Default port for MQTT is 1883
    PORT=1883
fi

echo "Listening to all topics on the MQTT broker at $BROKER:$PORT..."
mosquitto_sub -h "$BROKER" -p "$PORT" -t "#" -v "$OUTPUT_FILE" &
echo "Press [CTRL+C] to stop listening and save the file."
wait
