
# 🦙 Ollama Auto Puller (Robust Model Downloader)
> 🌍 **[Read this in Persian (فارسی) 🇮🇷](./README-fa.md)**

Downloading massive AI models via [Ollama](https://ollama.com/) on an unstable internet connection can be a nightmare. Frequent disconnections, interrupted downloads, and worst of all, a known Ollama bug that wipes out a 99% downloaded large layer and forces it to start from scratch!

This Bash script is designed to make the pulling process completely automated, bulletproof, and smart.

## ✨ Key Features

* 🔄 **Auto-Retry:** If your internet drops or the server times out, the script immediately and infinitely resumes the `pull` process until the model is fully downloaded.
* **Bypasses Ollama's `partial-0` Bug:** Sometimes, after finishing a huge layer, Ollama throws a `no such file` error, causing the entire downloaded layer to be lost. This script intelligently detects this error and creates a dummy file to satisfy the cleanup process, preventing the layer from re-downloading from scratch.
* **Batch Downloading:** Pass a list of models to the script, and it will download them sequentially in a queue.
* **Background Execution (via `tmux`):** Even if you shut down your laptop or lose your SSH connection to the server, the downloads will safely continue in the background.

--------------------------------------------------------------

## Setup \& Usage Guide

### 1\. Select Your Models

First, go to the Ollama search page at [ollama.com/search](https://ollama.com/search) to find your desired models (e.g., `llama3.3:70b` or `qwen3.6:35b`).

Next, edit the `ollama\_auto\ollma_puller.sh` file and add the model names to the `MODELS` array:

```bash
MODELS=(
    "llama3.3:70b"
    "qwen3.6:35b"
    "gemma4:31b"
)
```

### 2\. Install tmux (Crucial)

To ensure the download process doesn't stop when you turn off your laptop or lose your internet connection, you must run the script inside a `tmux` session. If you don't have it installed:

```bash
# Ubuntu / Debian
sudo apt install tmux

# CentOS / RHEL
sudo yum install tmux
```

### 3\. Run the Script

First, make the script executable:

```bash
chmod +x ollama\_auto\ollma_puller.sh
```

Now, create a new `tmux` session and run the script:

```bash
# 1. Create and enter a secure tmux environment
tmux new -s aipull

# 2. Run the script
./ollama\_auto\ollma_puller.sh
```

**How to Detach Safely (Without stopping the download):**
Now you can turn off your laptop! To exit the terminal without interrupting the script, press `Ctrl + B` on your keyboard, release them, and then press the `D` key.

**How to Re-attach and Check Status:**
Whenever you reconnect to your server via SSH, you can view the live download status by running:

```bash
tmux attach -t aipull
```

\---

## Technical Detail: How does this script fix the Ollama bug?

When downloading massive layers, you might encounter the following error in Ollama:

> `Error: remove /usr/share/ollama/.ollama/models/blobs/sha256-...-partial-0: no such file or directory`

This error occurs when the file is successfully downloaded and renamed, but Ollama's cleanup function attempts to delete the temporary (`partial`) file. Since the file was already renamed, it can't be found. Ollama crashes and restarts the download from 0%.

My script monitors the console output. As soon as it spots this specific error, it creates an empty file (`touch`) at that exact path. Ollama then successfully "deletes" this dummy file, the bug is bypassed, and the process continues. **Say goodbye to re-downloading tens of gigabytes!**

\---

*Developed for the open-source community. Feel free to fork, contribute, and improve!*

