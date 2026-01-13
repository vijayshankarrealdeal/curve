#!/bin/bash

# Definition of output file name
OUTPUT_FILE="flutter_lib_dump.txt"

# Check if the lib directory exists
if [ ! -d "lib" ]; then
    echo "Error: 'lib' directory not found. Are you in the root of your Flutter project?"
    exit 1
fi

# Clear the output file if it exists, or create a new one
> "$OUTPUT_FILE"

echo "Scanning 'lib' folder..."

# Find all .dart files inside lib recursively
find lib -type f -name "*.dart" | while read -r file; do
    # 1. Print a separator line
    echo "==============================================================================" >> "$OUTPUT_FILE"
    
    # 2. Print the File Name
    echo "FILE: $file" >> "$OUTPUT_FILE"
    
    # 3. Print another separator
    echo "==============================================================================" >> "$OUTPUT_FILE"
    
    # 4. Dump the file content
    cat "$file" >> "$OUTPUT_FILE"
    
    # 5. Add a few newlines at the end for spacing between files
    printf "\n\n" >> "$OUTPUT_FILE"
done

echo "Success! All code has been dumped to $OUTPUT_FILE"
