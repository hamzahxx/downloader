# YouTube, Instagram, and Pinterest Video Downloader

This Python script allows you to download videos from YouTube, Instagram, and Pinterest using the `yt_dlp` library. The program downloads the video in the best available quality and saves it to your local machine.

## Features

- Download videos in the best quality available.
- Supports YouTube, Instagram, and Pinterest platforms.
- Simple and user-friendly interface.
- Provides clear error messages for invalid or unsupported URLs.

## Prerequisites

1. Python 3 installed on your system.
2. Install the `yt_dlp` library:
   ```bash
   pip install yt-dlp
   ```

## Usage

1. Clone or download this repository to your local machine.
2. Navigate to the directory containing the script.
3. Run the script using Python:
   ```bash
   python3 downloader.py
   ```
4. Enter the URL of the video when prompted.
5. The video will be downloaded to the current directory with the title of the video as the filename.

## Code Example

Here is the main code:

```python
import yt_dlp

def download_video(url):
    ydl_opts = {
        'format': 'best',
        'outtmpl': './%(title)s.%(ext)s',
    }
    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            ydl.download([url])
            print("Downloaded successfully!")
    except yt_dlp.utils.DownloadError:
        print("Error: Unable to download the video. Please check the URL.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    video_url = input("Enter the video URL: ")
    download_video(video_url)
```

## Error Handling

- If the URL is invalid or unsupported, the script will display a clear error message.
- Any other exceptions will be caught and displayed for debugging purposes.

## Notes

- Ensure you have the necessary permissions to download content from the provided URL.
- The script uses `yt_dlp`, which supports a wide range of video platforms beyond YouTube, Instagram, and Pinterest. Check the [yt-dlp documentation](https://github.com/yt-dlp/yt-dlp) for a full list of supported sites.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
