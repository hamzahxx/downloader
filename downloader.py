#!/usr/bin/env python3

import yt_dlp

def download_video(url):
    ydl_opts = {
        'format': 'best',
        'outtmpl': '~/Downloads/%(title)s.%(ext)s',
        'restrictfilenames': True,  # Sanitizes filenames
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