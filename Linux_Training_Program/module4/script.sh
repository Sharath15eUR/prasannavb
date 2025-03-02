#!/bin/bash

# Check if input file is provided
if [ -z "$1" ]; then
    echo "Please provide the input file."
    exit 1
fi

# Input and Output file paths
input_file="$1"
output_file="output.txt"

# Initialize the output file
echo "" > "$output_file"

# Temporary variables to hold values
frame_time=""
wlan_fc_type=""
wlan_fc_subtype=""

# Read the input file line by line
while IFS= read -r line
do
    # Extract the "frame.time" value
    if [[ "$line" == *"frame.time"* ]]; then
        frame_time=$(echo "$line" | sed -E 's/.*"frame.time": "(.*)".*/\1/')
    fi

    # Extract the "wlan.fc.type" value
    if [[ "$line" == *"wlan.fc.type"* ]]; then
        wlan_fc_type=$(echo "$line" | sed -E 's/.*"wlan.fc.type": "(.*)".*/\1/')
    fi

    # Extract the "wlan.fc.subtype" value
    if [[ "$line" == *"wlan.fc.subtype"* ]]; then
        wlan_fc_subtype=$(echo "$line" | sed -E 's/.*"wlan.fc.subtype": "(.*)".*/\1/')
    fi

    # When all three parameters are found, write them to output.txt
    if [[ -n "$frame_time" && -n "$wlan_fc_type" && -n "$wlan_fc_subtype" ]]; then
        echo "\"frame.time\": \"$frame_time\"," >> "$output_file"
        echo "\"wlan.fc.type\": \"$wlan_fc_type\"," >> "$output_file"
        echo "\"wlan.fc.subtype\": \"$wlan_fc_subtype\"" >> "$output_file"
        echo "" >> "$output_file"  # Blank line between entries
        
        # Reset variables for next entry
        frame_time=""
        wlan_fc_type=""
        wlan_fc_subtype=""
    fi

done < "$input_file"

echo "Extraction complete. Results are saved in $output_file."
