# Standard Library Imports
import os
import time
import mimetypes

# Third-Party Imports
from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.responses import FileResponse
from pydantic import BaseModel

# Local Imports
from downloader import download_video


app = FastAPI()

class VideoRequest(BaseModel):
    url: str

# Configuration
DOWNLOAD_DIR = os.path.join(os.getcwd(), 'downloads')
MAX_AGE_SECONDS = 3600  # 1 hour

# Ensure download directory exists
os.makedirs(DOWNLOAD_DIR, exist_ok=True)

def cleanup_old_files():
    now = time.time()
    for f in os.listdir(DOWNLOAD_DIR):
        path = os.path.join(DOWNLOAD_DIR, f)
        if os.path.isfile(path) and (now - os.path.getmtime(path)) > MAX_AGE_SECONDS:
            os.remove(path)

@app.post("/download")
async def api_download_video(request: VideoRequest):
    # Run cleanup synchronously after download
    cleanup_old_files()
    try:
        filename = download_video(request.url)
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
    
    return {
        "message": "Download successful",
        "file_url": f"/files/{os.path.basename(filename)}"
    }

@app.get("/files/{filename}")
def serve_file(filename: str, background_tasks: BackgroundTasks):
    # Prevent directory traversal
    filename = os.path.basename(filename)
    file_path = os.path.join(DOWNLOAD_DIR, filename)
    
    if not os.path.exists(file_path):
        raise HTTPException(status_code=404, detail="File not found")
    
    # Auto-detect MIME type
    mime_type, _ = mimetypes.guess_type(filename)
    return FileResponse(
        file_path,
        media_type=mime_type or "application/octet-stream",
        filename=filename
    )