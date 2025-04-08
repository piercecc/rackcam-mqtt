#!/bin/bash

# Script to create an MQTT topic on a Mosquitto server

# Check if mosquitto_pub is installed
if ! command -v mosquitto_pub &> /dev/null; then
    echo "Error: mosquitto_pub is not installed. Please install Mosquitto tools."
    exit 1
fi
# Prompt user for input values
read -p "Enter Broker Address (e.g., localhost): " BROKER_ADDRESS
# Check if the broker address is valid
if ! [[ "$BROKER_ADDRESS" =~ ^[a-zA-Z0-9._-]+(:[0-9]+)?$ ]]; then
    echo "Error: Invalid broker address format. Use 'hostname:port' or 'hostname'."
    exit 1
fi
read -p "Enter Port (default is 1883): " PORT
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
read -p "Enter Username: " USERNAME
read -p "Enter Password: " PASSWORD
# Check if the username and password are provided
if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
    echo "Error: Username and password are required."
    exit 1
fi
read -p "Enter Topic Name: " TOPIC_NAME
# Check if the topic name is provided
if [ -z "$TOPIC_NAME" ]; then
    echo "Error: Topic name is required."
    exit 1
fi
# Check if the topic name is valid
# Check if the topic name starts with a slash
if [[ "$TOPIC_NAME" =~ ^/ ]]; then
    echo "Error: Topic name cannot start with a slash."
    exit 1
fi
# Check if the topic name contains a slash
if [[ "$TOPIC_NAME" =~ / ]]; then
    echo "Error: Topic name cannot contain a slash."
    exit 1
fi
read -p "Enter Subtopic Name: " SUBTOPIC_NAME
read -p "Enter Topic Value: " TOPIC_VALUE
# Check if the topic value is empty
if [ -z "$TOPIC_VALUE" ]; then
    echo "Error: Topic name cannot be empty."
    exit 1
fi
# Check if the topic value contains invalid characters
if ! [[ "$TOPIC_VALUE" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
    echo "Error: Invalid topic name format. Use alphanumeric characters, underscores, dashes, and slashes."
    exit 1
fi
# Check if the topic value starts with a slash
if [ -z "$TOPIC_VALUE" ]; then
    echo "Error: Topic name cannot start with a slash."
    exit 1
fi
read -p "Enter Message Value: " MESSAGE
# Publish a message to create the topic -p "$PASSWORD" -m "$MESSAGE"
if mosquitto_pub -h "$BROKER_ADDRESS" -p "$PORT" -t "$TOPIC_NAME/$SUBTOPIC_NAME/$TOPIC_VALUE" -r -u "$USERNAME" -p "$PASSWORD" -m "$MESSAGE" 2>error_output; then
    echo "Topic '$TOPIC_NAME', '$TOPIC_VALUE', '$MESSAGE' created successfully on broker '$BROKER_ADDRESS'."
else
    echo "Failed to create topic '$TOPIC_NAME', '$TOPIC_VALUE', '$MESSAGE' on broker '$BROKER_ADDRESS'."
    echo "Error details:"
    cat error_output
    rm -f error_output
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
    mosquitto_pub -h "$BROKER_ADDRESS" -p "$PORT" -t "$TOPIC_NAME/$SUBTOPIC_NAME/$TOPIC_VALUE" -r -u "$USERNAME" -p "$PASSWORD" -m "$MESSAGE"
    if [ $? -eq 0 ]; then
        echo "Subtopic: '$SUBTOPIC_NAME', Topic: '$TOPIC_VALUE', and Message: '$MESSAGE' created successfully on broker '$BROKER_ADDRESS'."
    else
        echo "Failed to create Subtopic: '$SUBTOPIC_NAME', Topic: '$TOPIC_VALUE', and Message: '$MESSAGE'."
        exit 1
    fi
fi
