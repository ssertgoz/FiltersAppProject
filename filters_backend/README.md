# Image Filters Backend API

This is a FastAPI-based backend service that provides image filtering capabilities for the FiltersApp Flutter application.

## Setup

1. Create a virtual environment:
```bash
python -m venv venv
```

2. Activate the virtual environment:
- On Windows:
```bash
.\venv\Scripts\activate
```
- On macOS/Linux:
```bash
source venv/bin/activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

## Running the Server

Start the FastAPI server using uvicorn:

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at `http://localhost:8000`

## API Endpoints

- `GET /`: Health check endpoint
- `POST /filter/edge-detection`: Apply edge detection to an image
- `POST /filter/blur`: Apply Gaussian blur to an image

## Testing the API

You can test the API using the built-in Swagger documentation at `http://localhost:8000/docs`

## Integration with Flutter App

The Flutter app can send HTTP requests to this backend service to process images. Make sure the Flutter app is configured with the correct backend URL. 