# Image Filters Backend API

A FastAPI-based backend service that provides image processing capabilities using OpenCV. This service is designed to work with the FiltersApp Flutter application.

## Prerequisites

- Python 3.11 or 3.12 (recommended)
- pip (Python package manager)
- Virtual environment module (venv)

## Project Setup

1. Clone the repository (if you haven't already):
```bash
git clone <repository-url>
cd filters_backend
```

2. Create a virtual environment:
```bash
# On macOS/Linux
python3.11 -m venv venv

# On Windows
python -m venv venv
```

3. Activate the virtual environment:
```bash
# On macOS/Linux
source venv/bin/activate

# On Windows
.\venv\Scripts\activate
```

4. Install dependencies:
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

## Running the Server

1. Make sure your virtual environment is activated
2. Start the FastAPI server:
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The server will be available at `http://localhost:8000`

## Testing the API

### Using Swagger UI (Recommended)
1. Open `http://localhost:8000/docs` in your web browser
2. You'll see all available endpoints
3. Click on an endpoint to expand it
4. Click "Try it out"
5. Upload an image and execute the request

### Using curl
```bash
# Test health check
curl http://localhost:8000

# Test edge detection (replace path/to/image.jpg with your image path)
curl -X POST -F "file=@path/to/image.jpg" http://localhost:8000/filter/edge-detection -o output.png

# Test blur filter
curl -X POST -F "file=@path/to/image.jpg" http://localhost:8000/filter/blur -o blurred.png
```

### Using Python script
Run the included test script:
```bash
python test_api.py
```

## Available Endpoints

- `GET /` - Health check endpoint
- `POST /filter/edge-detection` - Apply edge detection to an image
- `POST /filter/blur` - Apply Gaussian blur to an image

## Response Formats

All image processing endpoints return:
- Success: Processed image in PNG format
- Error: JSON with error details

## Common Issues

1. **Installation Problems**:
   - Make sure you're using Python 3.11 or 3.12
   - Try upgrading pip: `pip install --upgrade pip`
   - If still having issues, delete venv and recreate it

2. **Server Won't Start**:
   - Ensure no other service is using port 8000
   - Check if virtual environment is activated
   - Verify all dependencies are installed

3. **Image Processing Errors**:
   - Verify the image format is supported (JPEG, PNG)
   - Check if the image file exists and is readable

## Development

- The server runs in debug mode by default (--reload flag)
- API documentation is available at `/docs` and `/redoc`
- Logs are printed to the console

## Integration with Flutter App

The Flutter app should be configured to send HTTP requests to:
- Development: `http://localhost:8000`
- Production: Your deployed server URL

## License

[Your License Here] 