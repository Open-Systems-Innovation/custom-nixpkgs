{ pkgs,
  ...}:

pkgs.writeShellScriptBin "petscrc-update" ''
  #!/bin/bash

  # Step 1: Generate the .petscrc file
  ./main -help > .petscrc

  # Step 2: Define the file to clean
  input_file=".petscrc"

  # Create a temporary file to store the cleaned output
  temp_file=$(mktemp)

  # Step 3: Read the file line by line and clean it
  while IFS= read -r line; do
    # Trim leading whitespace
    line=$(echo "$line" | sed 's/^[ \t]*//')

    # Replace the first ':' with '#' for option lines
    if [[ "$line" == -*:* ]]; then
      line=$(echo "$line" | sed 's/:/ #/')
    fi

    # Comment out every line
    echo "# $line" >> "$temp_file"

  done < "$input_file"

  # Step 4: Replace the original .petscrc file with the cleaned version
  mv "$temp_file" "$input_file"

  echo "Cleaned and commented file saved to $input_file"
''
