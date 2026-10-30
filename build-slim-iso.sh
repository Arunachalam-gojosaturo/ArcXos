#!/usr/bin/env bash
# ArcXos Slim ISO Build Automation Script

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_DIR="${SCRIPT_DIR}/slim-iso"
WORK_DIR="${PROFILE_DIR}/work"
OUT_DIR="${PROFILE_DIR}/out"

echo "========================================================"
echo "         ArcXos Slim ISO Build Automation"
echo "========================================================"
echo "[+] Profile Directory : ${PROFILE_DIR}"
echo "[+] Working Directory : ${WORK_DIR}"
echo "[+] Output Directory  : ${OUT_DIR}"
echo "========================================================"

# Check root privileges
if [ "$EUID" -ne 0 ]; then
  echo "[-] ERROR: This script must be run as root to construct squashfs ISO images."
  echo "    Please run: sudo ./build-slim-iso.sh"
  exit 1
fi

# Check mkarchiso availability
if ! command -v mkarchiso &>/dev/null; then
  echo "[-] ERROR: 'mkarchiso' command not found."
  echo "    Please install archiso: sudo pacman -S archiso"
  exit 1
fi

# Automatically clean old build work directories to reclaim disk space
echo "[+] Cleaning slim-iso build work directory..."
rm -rf "${WORK_DIR}"

# Prepare fresh build directories
mkdir -p "${WORK_DIR}" "${OUT_DIR}"

echo "[+] Starting ISO build process via mkarchiso..."
mkarchiso -v -w "${WORK_DIR}" -o "${OUT_DIR}" "${PROFILE_DIR}"

echo "========================================================"
echo "    SUCCESS! Slim ISO Build Complete."
echo "========================================================"
echo "[+] ISO Location: ${OUT_DIR}/"
ls -lh "${OUT_DIR}"/*.iso 2>/dev/null || true
echo "========================================================"
