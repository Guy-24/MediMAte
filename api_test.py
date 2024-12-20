import requests

# URL of the API endpoint
url = 'http://localhost:8000/process-image/'

# Path to the image file you want to upload
image_path = "pill/3.jpg" # Replace with the actual path to your image

# Open the image file in binary mode
with open(image_path, 'rb') as image_file:
    # Prepare the files dictionary for the request
    files = {
        'file': (image_file.name, image_file, 'image/jpeg')
    }

    try:
        # Send the POST request with the file
        response = requests.post(url, files=files)

        # Check if the request was successful
        if response.status_code == 200:
            # Parse the JSON response
            data = response.json()
            print("Response from the API:")
            print(data)
        else:
            print(f"Error: Received status code {response.status_code}")
            print("Response content:")
            print(response.text)

    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")
