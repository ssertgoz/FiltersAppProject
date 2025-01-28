import requests

# Test health check
response = requests.get('http://localhost:8000')
print("Health check:", response.json())

# Test image processing
with open('path/to/test/image.jpg', 'rb') as img:
    files = {'file': img}
    response = requests.post('http://localhost:8000/filter/edge-detection', files=files)
    
    if response.status_code == 200:
        # Save the processed image
        with open('output.png', 'wb') as f:
            f.write(response.content)
        print("Image processed successfully!")
    else:
        print("Error:", response.json()) 