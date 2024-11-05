#!/bin/bash

special_characters=('!' '@' '#' '$' '%' '^' '&' '*')
numbers=(0 1 2 3 4 5 6 7 8 9)

output_file="james_passwords.txt"

> "$output_file"

for special in "${special_characters[@]}"; do
    for number in "${numbers[@]}"; do
    
        echo "${special}${number}rockyou" >> "$output_file"
        
        echo "${number}${special}rockyou" >> "$output_file"
        
        echo "rockyou${number}${special}" >> "$output_file"
        
        echo "rockyou${special}${number}" >> "$output_file"
    done
done

echo "Password list generated in $output_file"
