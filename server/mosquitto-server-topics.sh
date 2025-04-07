#!/bin/bash

# Script to create an MQTT topic on a Mosquitto server

# Check if mosquitto_pub is installed
if ! command -v mosquitto_pub &> /dev/null; then
    echo "Error: mosquitto_pub is not installed. Please install Mosquitto tools."
    exit 1
fi

# Prompt user for input values
read -p "Enter Broker Address (e.g., localhost): " BROKER_ADDRESS
read -p "Enter Port (default is 1883): " PORT
read -p "Enter Username: " USERNAME
read -p "Enter Password: " PASSWORD
read -p "Enter Topic Name: " TOPIC_NAME
read -p "Enter Subtopic Name: " SUBTOPIC_NAME
read -p "Enter Topic Value: " TOPIC_VALUE
read -p "Enter Message Value: " MESSAGE

# Use default port if not provided
if [ -z "$PORT" ]; then
    PORT=1883
fi

# Combine broker address and port
BROKER_ADDRESS="$BROKER_ADDRESS:$PORT"

# Check for required arguments
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <broker_address> <port> <topic_name> <username> <password> [message]"
    echo "Example: $0 localhost my/topic 'Hello, MQTT!'"
    exit 1
fi

BROKER_ADDRESS=$1
# Check if the broker address is valid
if ! [[ "$BROKER_ADDRESS" =~ ^[a-zA-Z0-9._-]+(:[0-9]+)?$ ]]; then
    echo "Error: Invalid broker address format. Use 'hostname:port' or 'hostname'."
    exit 1
fi
PORT=${BROKER_ADDRESS##*:} # Extract port if present
# Check if the port is a valid number
if [[ "$port" =~ ^[0-9]+$ ]]; then
    if [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo "Error: Port number must be between 1 and 65535."
        exit 1
    fi
else
    # Default port for MQTT is 1883
    BROKER_ADDRESS="$BROKER_ADDRESS:1883"
fi
# Check if the topic name is provided
if [ -z "$2" ]; then
    echo "Error: Topic name is required."
    exit 1
fi
# Check if the topic name is valid
# Check if the topic name contains invalid characters
if ! [[ "$2" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
    echo "Error: Invalid topic name format. Use alphanumeric characters, underscores, dashes, and slashes."
    exit 1
fi
# Check if the topic name starts with a slash
if [[ "$2" =~ ^/ ]]; then
    echo "Error: Topic name cannot start with a slash."
    exit 1
fi
# Check if the topic name contains a slash
if [[ "$2" =~ / ]]; then
    echo "Error: Topic name cannot contain a slash."
    exit 1
fi
TOPIC_NAME=$2
SUBTOPIC_NAME=${TOPIC_NAME#*/} # Remove leading slash if present
# Check if the topic name is empty
if [ -z "$SUBTOPIC_NAME" ]; then
    echo "Error: SubTopic name cannot be empty."
    exit 1
fi
# Check if the topic name contains invalid characters
# Check if the topic name is valid
if ! [[ "$TOPIC_NAME" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
    echo "Error: Invalid topic name format. Use alphanumeric characters, underscores, dashes, and slashes."
    exit 1
fi
# Check if the topic name starts with a slash
TOPIC_VALUE=${TOPIC_NAME%%/*}
if [ -z "$TOPIC_VALUE" ]; then
    echo "Error: Topic name cannot start with a slash."
    exit 1
fi
MESSAGE=${3:-"Default message"}

USERNAME="your_username" # Replace with your username
PASSWORD="your_password" # Replace with your password
# Check if the username and password are provided
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
    echo "Error: Username and password are required."
    exit 1
fi
# Check if the username and password are valid
if ! [[ "$USERNAME" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "Error: Invalid username format. Use alphanumeric characters, underscores, and dashes."
    exit 1
fi
if ! [[ "$PASSWORD" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "Error: Invalid password format. Use alphanumeric characters, underscores, and dashes."
    exit 1
fi

# Publish a message to create the topic
mosquitto_pub -h "$BROKER_ADDRESS" -p "$PORT" -t "$TOPIC_NAME/$SUBTOPIC_NAME/$TOPIC_VALUE" -r --username "$USERNAME" --password "$PASSWORD" -m "$MESSAGE"

if [ $? -eq 0 ]; then
    echo "Topic '$TOPIC_NAME' created successfully on broker '$BROKER_ADDRESS'."
else
    echo "Failed to create topic '$TOPIC_NAME'."
    exit 1
fi

read -p "Would you like to add a subtopic? (y/n): " ADD_SUBTOPIC
if [[ "$ADD_SUBTOPIC" =~ ^[Yy]$ ]]; then
    read -p "Enter Subtopic Name: " SUBTOPIC_NAME
    read -p "Enter Subtopic Value: " SUBTOPIC_VALUE
    read -p "Enter Subtopic Message: " SUBTOPIC_MESSAGE
    # Check if the subtopic name is valid
    if ! [[ "$SUBTOPIC_NAME" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
        echo "Error: Invalid subtopic name format. Use alphanumeric characters, underscores, dashes, and slashes."
        exit 1
    fi
    # Check if the subtopic name starts with a slash
    if [[ "$SUBTOPIC_NAME" =~ ^/ ]]; then
        echo "Error: Subtopic name cannot start with a slash."
        exit 1
    fi
    # Check if the subtopic name contains a slash
    if [[ "$SUBTOPIC_NAME" =~ / ]]; then
        echo "Error: Subtopic name cannot contain a slash."
        exit 1
    fi
    # Check if the subtopic name is empty
    if [ -z "$SUBTOPIC_NAME" ]; then
        echo "Error: Subtopic name cannot be empty."
        exit 1
    fi
    # Check if the topic value contains invalid characters
    if ! [[ "$TOPIC_VALUE" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
        echo "Error: Invalid subtopic name format. Use alphanumeric characters, underscores, dashes, and slashes."
        exit 1
    fi
    # Check if the topic value starts with a slash
    if [[ "$TOPIC_VALUE" =~ ^/ ]]; then
        echo "Error: Subtopic value cannot start with a slash."
        exit 1
    fi
    # Check if the topic value contains a slash
    if [[ "$TOPIC_VALUE" =~ / ]]; then
        echo "Error: Subtopic value cannot contain a slash."
        exit 1
    fi
    # Check if the topic value is empty
    if [ -z "$TOPIC_VALUE" ]; then
        echo "Error: Subtopic value cannot be empty."
        exit 1
    fi
    # Check if the subtopic message is provided
    if [ -z "$SUBTOPIC_MESSAGE" ]; then
        echo "Error: Subtopic message is required."
        exit 1
    fi
    # Check if the subtopic message contains invalid characters
    if ! [[ "$SUBTOPIC_MESSAGE" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
        echo "Error: Invalid subtopic message format. Use alphanumeric characters, underscores, dashes, and slashes."
        exit 1
    fi
    # Check if the subtopic message starts with a slash
    if [[ "$SUBTOPIC_MESSAGE" =~ ^/ ]]; then
        echo "Error: Subtopic message cannot start with a slash."
        exit 1
    fi
    # Check if the subtopic message contains a slash
    if [[ "$SUBTOPIC_MESSAGE" =~ / ]]; then
        echo "Error: Subtopic message cannot contain a slash."
        exit 1
    fi
    # Check if the subtopic message is empty
    if [ -z "$SUBTOPIC_MESSAGE" ]; then
        echo "Error: Subtopic message cannot be empty."
        exit 1
    fi
    # Publish a message to create the subtopic
    mosquitto_pub -h "$BROKER_ADDRESS" -p "$PORT" -t "$TOPIC_NAME/$SUBTOPIC_NAME/$TOPIC_VALUE" -r --username "$USERNAME" --password "$PASSWORD" -m "$MESSAGE"
    if [ $? -eq 0 ]; then
        echo "Subtopic '$SUBTOPIC_NAME' created successfully on broker '$BROKER_ADDRESS'."
    else
        echo "Failed to create subtopic '$SUBTOPIC_NAME'."
        exit 1
    fi
fi
