from fastapi import FastAPI, UploadFile, File, HTTPException, Response
from fastapi.responses import Response
from fastapi.middleware.cors import CORSMiddleware
import numpy as np
import cv2
from PIL import Image
import io
import asyncio

app = FastAPI(title="Image Filter API",
             description="API for applying image filters using OpenCV",
             version="1.0.0")

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Image Filter API is running"}

@app.post("/filter/edge-detection")
async def apply_edge_detection(file: UploadFile = File(...)):
    try:
        # Add 3 second delay to simulate heavy processing
        await asyncio.sleep(3)
        
        # Read image file
        contents = await file.read()
        nparr = np.frombuffer(contents, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        # Apply Canny edge detection
        edges = cv2.Canny(img, 100, 200)
        
        # Convert back to RGB for consistent output
        edges_rgb = cv2.cvtColor(edges, cv2.COLOR_GRAY2RGB)
        
        # Convert the processed image to bytes
        is_success, buffer = cv2.imencode(".png", edges_rgb)
        if not is_success:
            raise HTTPException(status_code=500, detail="Failed to process image")
        
        return Response(content=buffer.tobytes(), media_type="image/png")
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/filter/blur")
async def apply_blur(file: UploadFile = File(...)):
    try:
        # Add 3 second delay to simulate heavy processing
        await asyncio.sleep(3)
        
        contents = await file.read()
        nparr = np.frombuffer(contents, np.uint8)
        img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        # Apply Gaussian blur
        blurred = cv2.GaussianBlur(img, (15, 15), 0)
        
        # Convert the processed image to bytes
        is_success, buffer = cv2.imencode(".png", blurred)
        if not is_success:
            raise HTTPException(status_code=500, detail="Failed to process image")
        
        return Response(content=buffer.tobytes(), media_type="image/png")
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) 