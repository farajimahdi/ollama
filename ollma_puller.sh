#!/bin/bash
# ══════════════════════════════════════════════════════
# Mahdi Faraji
# Mahdi.Faraji@gmail.com
# Version : 1.0.1
# Jul 2026
# https://github.com/farajimahdi/ollama
# ══════════════════════════════════════════════════════
MODELS=("llama3.3:70b" "qwen3.6:35b" "gemma4:31b" "llama4:latest")

echo "══════════════════════════════════════════════════════"
echo "Starting Robust Ollama Auto Puller..."
echo "Total models to download: ${#MODELS[@]}"
echo "══════════════════════════════════════════════════════"

for MODEL in "${MODELS[@]}"; do
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] -> Starting validation for: $MODEL"
    
    while true; do
        
       if ollama list | awk '{print $1}' | grep -qx "$MODEL"; then
            echo "[$(date +'%Y-%m-%d %H:%M:%S')] -> SUCCESS: $MODEL is fully downloaded and verified!"
            echo "-------------------------------------------------"
            break
        fi
        
        echo "[$(date +'%Y-%m-%d %H:%M:%S')] -> Pulling $MODEL..."
        
        ollama pull "$MODEL"
        
        if ollama list | awk '{print $1}' | grep -qx "$MODEL"; then
            echo "[$(date +'%Y-%m-%d %H:%M:%S')] -> SUCCESS: $MODEL downloaded successfully!"
            echo "-------------------------------------------------"
            break
        else
            echo "[$(date +'%Y-%m-%d %H:%M:%S')] -> ERROR: Download interrupted (e.g., unexpected EOF)."
            echo "Waiting 10 seconds before resuming to protect partial files..."
            sleep 10
        fi
        
    done
done

echo "══════════════════════════════════════════════════════"
echo "[$(date +'%Y-%m-%d %H:%M:%S')] -> All models downloaded successfully! Enjoy your AI models."
