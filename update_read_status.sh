#!/bin/bash

# This script is used to update the read status: Create the folder for the concerned chapter and create readme.md file in it.
# Then update the base readme.md file by adding [Reading...] in front of the chapter name.
#
# Process:
# Display the list of chapters in the base readme.md file.
# Ask the user to enter the chapter number to update the read status.
# Check if the chapter number is valid.
# Check if the chapter is already read.
# Create the folder for the concerned chapter and create readme.md file in it.
#
# Author: Abdoufermat
# Date: 2020-02-27

# Display the list of chapters in the base readme.md file.

# Read the readme.md file and extract chapter information
readme_file="README.md"
chapter_pattern="^\- \[Chapter([0-9]+): (.+)\]\((.+)\)$"

# Declare arrays to store chapter numbers, titles, and links
declare -a chapter_numbers
declare -a chapter_titles
declare -a chapter_directories

echo -e "List of chapters: \n"
echo -e "--------------------------------------------------\n"
# Read each line from the readme file
while IFS= read -r line; do
    # Check if the line matches the chapter pattern
    if [[ $line =~ $chapter_pattern ]]; then
        chapter_numbers+=("${BASH_REMATCH[1]}")
        chapter_titles+=("${BASH_REMATCH[2]}")
        chapter_directories+=("${BASH_REMATCH[3]}")
    fi
done <"$readme_file"

# Display the list of chapters and associated directories in order
for ((i = 0; i < ${#chapter_numbers[@]}; i++)); do
    chapter_number="${chapter_numbers[$i]}"
    chapter_title="${chapter_titles[$i]}"
    chapter_link="${chapter_directories[$i]}"

    echo "Chapter $chapter_number: $chapter_title"
done

echo -e "\n\n"

# Ask the user to enter the chapter number to update the read status.
read -p "Enter the chapter number to update the read status: " chapter_number

# Check if the chapter number is valid.
if [[ ! " ${chapter_numbers[@]} " =~ " ${chapter_number} " ]]; then
    echo "Invalid chapter number: $chapter_number\n"
    exit 1
fi

echo -e "\n\n"

# Check if the chapter is already read (i.e., the directory exists)
chapter_directory="${chapter_directories[$chapter_number - 1]}"
if [ -d "$chapter_directory" ]; then
    echo "Chapter $chapter_number is already read or reading\n"
    exit 1
fi

echo -e "Chapter $chapter_number is not read yet\n\n Creating the folder for the concerned chapter and create readme.md file in it.\n...."
# Create the folder for the concerned chapter and create readme.md file in it.
mkdir -p "$(dirname "$chapter_directory")/data"
mkdir -p "$(dirname "$chapter_directory")/training"
echo -e "# Chapter $chapter_number: ${chapter_titles[$chapter_number - 1]}\n\n" >"$(dirname "$chapter_directory")/readme.md"

echo -e "\n\nWe are set!!\n\nGood luck with Chapter $chapter_number!!\n"
