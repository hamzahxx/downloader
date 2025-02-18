from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from pydantic import BaseModel
import os
import mimetypes
from downloader import download_video

app = FastAPI()

class VideoRequest(BaseModel):
    url: str

DOWNLOAD_DIR = os.path.join(os.getcwd(), 'downloads')

@app.post("/download")
def api_download_video(request: VideoRequest):
    try:
        filename = download_video(request.url)
    except yt_dlp.utils.DownloadError as e:
        raise HTTPException(400, detail="Invalid URL or download error")
    except Exception as e:
        raise HTTPException(500, detail=str(e))
    
    return {
        "message": "Download successful",
        "file_url": f"/files/{os.path.basename(filename)}"
    }

@app.get("/files/{filename}")
def serve_file(filename: str):
    # Prevent directory traversal
    filename = os.path.basename(filename)
    file_path = os.path.join(DOWNLOAD_DIR, filename)
    
    if not os.path.exists(file_path):
        raise HTTPException(404, detail="File not found")
    
    # Auto-detect MIME type
    mime_type, _ = mimetypes.guess_type(filename)
    return FileResponse(
        file_path,
        media_type=mime_type or "application/octet-stream",
        filename=filename
    )