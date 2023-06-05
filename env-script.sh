#!/bin/bash

# Do NOT Delete This script file, this is used for setting up 
# the basic ENV variables that you may need to use 

# Fetch environment variables containing "PUBLIC"
env_variables=$(printenv | grep "PUBLIC")

# Create a temporary file for storing the new environment variables
temp_file=$(mktemp)

# Iterate over each environment variable
while IFS= read -r line; do
  # Extract the variable name
  variable_name=$(echo "$line" | cut -d '=' -f 1)
  
  # Join with "VITE_" prefix
  new_variable_name="VITE_${variable_name}"
  
  # Append to temporary file
  echo -e "\n$new_variable_name=${!variable_name}" >> "$temp_file"
done <<< "$env_variables"

# Cleanup: Delete existing environment variables in .env file with the same keys
while IFS= read -r line; do
  # Extract the variable name from the .env file
  existing_variable_name=$(echo "$line" | cut -d '=' -f 1)
  
  # Remove the corresponding line from the .env file
  sed -i "/^$existing_variable_name=/d" .env
done < "$temp_file"

# Append the new environment variables to the .env file
cat "$temp_file" >> .env

# Remove the temporary file
rm "$temp_file"