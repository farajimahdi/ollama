#!/bin/bash
# ══════════════════════════════════════════════════════
# Mahdi Faraji
# Mahdi.Faraji@gmail.com
# Version : 1.0.1
# Jul 2026
# https://github.com/farajimahdi/ollama
# ══════════════════════════════════════════════════════
MODELS=("llama3.3:70b" "qwen3.6:35b" "gemma4:31b" "llama4:latest")
RETRY_DELAY=5

echo "Starting Advanced Ollama Puller..."
echo "═════════════════════════════════════════════════"

for MODEL in "${MODELS[@]}"; do
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] -> Starting: $MODEL"
    
    while true; do
        OUTPUT=$(ollama pull "$MODEL" 2>&1 | tee /dev/tty)
        EXIT_CODE=${PIPESTATUS[0]}
        
        if [ $EXIT_CODE -eq 0 ]; then
            echo "[$(date +'%Y-%m-%d %H:%M:%S')] -> Success: $MODEL"
            break
        else
            if echo "$OUTPUT" | grep -q "Error: remove .* no such file or directory"; then
                MISSING_FILE=$(echo "$OUTPUT" | grep -oP 'remove \K[^\:]+')             
                if [ -n "$MISSING_FILE" ]; then
                    echo "[!] Ollama Bug Detected! Creating dummy file to bypass:"
                    echo " -> touching $MISSING_FILE"
                    touch "$MISSING_FILE"
                    echo " -> Bypass applied. Resuming..."
                    continue
                fi
            fi
            
            echo "[$(date +'%Y-%m-%d %H:%M:%S')] -> Interrupted. Retrying in $RETRY_DELAY sec..."
            sleep $RETRY_DELAY
        fi
    done
done
