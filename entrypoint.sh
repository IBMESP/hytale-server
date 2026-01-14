#!/bin/bash
set -e

echo "Hytale Docker Entrypoint"

MACHINE_ID_DIR="$SERVER_FILES/.machine-id"
mkdir -p "$MACHINE_ID_DIR"

if [ ! -f "$MACHINE_ID_DIR/uuid" ]; then
    echo "Generating persistent machine-id for encrypted auth..."

    MACHINE_UUID=$(cat /proc/sys/kernel/random/uuid)
    MACHINE_UUID_NO_DASH=$(echo "$MACHINE_UUID" | tr -d '-' | tr '[:upper:]' '[:lower:]')
    
    echo "$MACHINE_UUID_NO_DASH" > "$MACHINE_ID_DIR/machine-id"
    echo "$MACHINE_UUID_NO_DASH" > "$MACHINE_ID_DIR/dbus-machine-id"
    echo "$MACHINE_UUID" > "$MACHINE_ID_DIR/product_uuid"
    echo "$MACHINE_UUID" > "$MACHINE_ID_DIR/uuid"
    
    chown -R 1001:1001 "$MACHINE_ID_DIR"
fi

DATA=/hytale-server
SERVER_DIR="$DATA/Server"
ASSETS="$DATA/Assets.zip"
CREDS="$DATA/.hytale-downloader-credentials.json"

needs_download=0

if [ ! -f "$SERVER_DIR/HytaleServer.jar" ]; then
  echo "Server not found"
  needs_download=1
fi

if [ ! -f "$ASSETS" ]; then
  echo "Assets.zip not found"
  needs_download=1
fi

if [ $needs_download -eq 1 ]; then
  echo "Download required"

  # --- Downloader binary ---
  if [ ! -f "$DATA/hytale-downloader-linux-amd64" ]; then
    echo "Downloading Hytale downloader..."

    rm -rf /tmp/downloader
    mkdir -p /tmp/downloader

    wget https://downloader.hytale.com/hytale-downloader.zip -O /tmp/downloader.zip
    unzip -o /tmp/downloader.zip -d /tmp/downloader

    cp /tmp/downloader/hytale-downloader-linux-amd64 "$DATA/"
    chmod +x "$DATA/hytale-downloader-linux-amd64"
  fi

  echo
  echo "Starting Hytale downloader..."
  echo "⚠️  You may be asked to authenticate via browser"
  echo

  "$DATA/hytale-downloader-linux-amd64" -download-path server.zip

  echo
  echo "Looking for downloaded server zip..."

  SERVER_ZIP="server.zip"

  if [ -z "$SERVER_ZIP" ]; then
    echo "❌ No server zip found after download"
    exit 1
  fi

  echo "Found: $SERVER_ZIP"
  echo "Extracting..."

  unzip -o "$SERVER_ZIP" -d "$DATA"
	rm "$SERVER_ZIP"
fi

if [ ! -f "$SERVER_DIR/HytaleServer.jar" ]; then
  echo "❌ HytaleServer.jar still not found after extraction"
  exit 1
fi

if [ ! -f "$ASSETS" ]; then
  echo "❌ Assets.zip still not found after extraction"
  exit 1
fi

echo
echo "Starting Hytale Server"
cd "$SERVER_DIR"

exec java -jar HytaleServer.jar --assets ../Assets.zip

