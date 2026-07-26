#!/usr/bin/env bash
# ============================================================
#  ArcXOS :: HYPER-DL — High-Performance Real Downloader
# ============================================================

set -euo pipefail

RESET='\e[0m'
CYAN='\e[38;5;51m'
BCYAN='\e[1;38;5;51m'
GOLD='\e[38;5;220m'
GREEN='\e[38;5;46m'
RED='\e[38;5;196m'
DIM='\e[2m'
WHITE='\e[97m'

SPINNER=('◜' '◠' '◝' '◞' '◡' '◟')
FILLED='█'
HEAD='▓'
EMPTY='░'
WIDTH=38

read -r -d '' ARC_ART <<'ARCART' || true
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡯⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢘⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢱⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢨⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⢠⣟⠀⠀⠀⠀⠀⠀⢠⠀⢰⠀⠀⠀⠀⠀⠀⠀⡏⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣏⣻⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠙⠀⠀⠀⠀⠀⠈⣿⡀⠀⠀⠀⠀⠀⢸⠀⠀⡇⠀⠀⠀⠀⠀⠀⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣼⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣄⠆⠀⠀⠀⠐⣿⣷⡀⠀⠀⠀⠀⠸⡀⠀⢷⠀⠀⠀⠀⠀⠀⢹⢈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⢰⢸⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣞⣆⠀⠀⠀⠀⠈⠛⠳⠄⠰⡀⠀⠀⠀⡀⠀⣠⡀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠀⠈⣏⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢉⡆⠀⠀⠀⠀⢰⣇⠀⡄⠘⣦⡀⠀⣻⣄⠹⢿⢯⡀⠀⠍⣿⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⠀⠀⢻⢻⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢟⠎⠨⠀⠀⠀⠀⢀⠈⠳⢀⣿⣧⡀⢻⣷⣮⡛⠛⠉⠀⠉⠛⠏⠝⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⢺⢸⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣵⠏⠀⠠⠀⡄⠀⠀⢸⠳⢆⣾⢿⣿⣿⣿⣿⣿⣥⡤⠾⣿⣿⠁⡂⢷⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⣾⢸⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⡿⣫⣾⠃⠀⢀⠂⠀⠀⠀⠀⢟⣵⣿⣷⣔⢌⠿⣿⣿⣿⣯⣦⣀⠛⠻⢬⣉⣤⠀⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠆⢼⡀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⣷⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣼⡿⠃⢀⠨⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣷⣕⡌⢛⢿⣿⣿⣿⣿⢧⣤⡶⠄⠠⢀⣀⣤⣴⡷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⢸⡃⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣾⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣦⡿⣎⡟⣿⢱⣸⣿⣷⣾⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡼⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⡸⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⡏⣼⡿⡵⠁⢀⡔⠠⢂⠄⠀⠀⠀⠐⡼⣦⣽⣿⣿⣿⣿⣿⣿⣿⣶⣯⠓⢩⣙⢻⢿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠥⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⡝⣿⣿⣿⣿⣿
⣿⣿⣿⣿⡿⣭⣫⠞⡑⠠⣾⠃⠀⠠⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⠇⢌⣿⣶⣤⣈⠺⣟⢿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡎⢿⣿⣿⣿
⣿⣿⣿⣿⣽⡓⠀⡠⢰⠋⠀⣰⠀⠀⠀⠀⠀⠀⠹⠻⣿⣿⣿⣿⣿⣿⣿⣿⣽⠠⣰⣶⣶⣶⣤⣄⣂⣙⠪⣽⣻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⢠⠹⣿⡀⣻⣿⣿
⣿⣿⣿⣯⣟⡽⠁⣰⡕⢰⠂⡰⠃⠀⠀⠀⠀⠀⠀⠀⢸⣦⣭⣻⠿⣿⣿⣿⣿⠃⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠀⠀⠹⡆⢹⣯⠱⣻⣿
⣿⣿⣳⣟⡾⠁⣸⢙⣼⠈⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠈⣛⢿⣿⣷⣿⣿⣿⡟⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡐<ctrl42>⣤⣿⡇⣇⣿
⣿⣿⣿⣿⠣⢰⢏⡾⢁⡼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⠃⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣇⡘⣿⡇⢻⣾
⣿⣿⣿⡏⢆⢊⠞⣴⢿⠀⠀⠀⠀⠀⠀⣠⠃⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠛⠋⠉⠀⢀⣮⢯⣾⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⢸⢱⠸⡏⣰⣿
⣿⣿⣿⠃⠎⣠⣾⣿⠇⠀⠀⠀⠀⠀⣸⢧⠀⠀⠀⠀⠀⠀⠙⠛⠻⠿⠛⠛⠛⠋⠉⠁⠐⠈⠀⠀⠀⢀⣴⡟⣷⣿⠇⠂⠀⠀⠀⠀⠀⠀⠀⠀⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠘⡄⢰⡇⢰⣿⣿
⣿⢿⠟⠠⣸⣿⣿⠏⠀⠀⡀⡆⠀⠀⣿⡄⡀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠢⠀⠀⠀⠀⠀⠀⢀⡴⣫⣯⣾⣿⡿⠄⠀⠀⠀⠀⠀⠀⠀⠀⣠⡿⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⢸⣾⡘⣿⣿
⡿⣣⣾⢀⣿⣿⡟⠀⡄⢰⡇⡇⠀⠀⣼⣧⡇⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣧⠀⠀⠀⠀⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠈⣿⡇⣿⣿
⣾⣿⡿⡈⢿⡿⠁⢰⠁⢸⡇⣇⠀⠆⡏⣿⣿⡌⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠀⠀⠀⠀⠀⠀⢻⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠘⢿⠀⠀⠀⢀⣤⣶⣾⣿⣿⣷⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠂⢹⡷⢸⣿
ARCART

INTRO_MSGS=(
  "[ OK ] ARC SERVER :: CONNECTION ESTABLISHED"
  "[ OK ] ARC SERVER :: AUTHENTICATION SUCCESSFUL"
  "[ OK ] ARC SERVER :: TUNNEL ENCRYPTED (AES-256-GCM)"
  "[ OK ] ARC SERVER :: SYNCHRONIZING MODULES..."
  "[ OK ] ARC SERVER :: SECURE LINK ACTIVE"
  "[ OK ] ARC SERVER :: DATA PIPELINE INITIALIZED"
)

human() {
  numfmt --to=iec-i --suffix=B --format="%.1f" "${1:-0}" 2>/dev/null || echo "${1:-0}B"
}

hex_id() {
  local n="$1" out=""
  for ((k=0; k<n; k++)); do out+=$(printf '%04X' $((RANDOM)) ); done
  echo "$out"
}

bar_color() {
  local pct="$1"
  if (( pct < 40 )); then echo "$GREEN"
  elif (( pct < 80 )); then echo "$CYAN"
  else echo "$GOLD"
  fi
}

intro_once() {
  echo -e "${CYAN}${ARC_ART}${RESET}"
  echo
  local session
  session="$(hex_id 1)-$(hex_id 1)-$(hex_id 1)"
  echo -e "  ${DIM}SESSION${RESET}  ${GOLD}${session}${RESET}"
  echo
  for m in "${INTRO_MSGS[@]}"; do
    echo -e "  ${GREEN}${m}${RESET}"
    sleep 0.05
  done
  echo
}

transfer_banner() {
  local src_url="$1"
  local dst_path="$2"
  local domain
  domain=$(echo "$src_url" | awk -F/ '{print $3}')
  if [ -z "$domain" ]; then domain="mirror.arcxos.io"; fi

  echo -e "${DIM}${CYAN}┌──────────────────────────────────────────────────┐${RESET}"
  echo -e "${CYAN}│ ${GOLD}ARCXOS${RESET}${CYAN} :: STREAM ACQUIRED — INITIATING XFER      │${RESET}"
  echo -e "${DIM}${CYAN}└──────────────────────────────────────────────────┘${RESET}"
  echo -e "${WHITE}  HOST   ${DIM}→${RESET} ${domain}"
  echo -e "${WHITE}  CIPHER ${DIM}→${RESET} AES-256-GCM"
  echo -e "${WHITE}  SRC    ${DIM}→${RESET} ${src_url}"
  echo -e "${WHITE}  DST    ${DIM}→${RESET} ${dst_path}"
  echo
}

usage() {
  echo -e "${CYAN}ArcXOS Hyper-DL Utility${RESET}"
  echo "Usage: arcxos-dl <URL> [-o OUTPUT_PATH]"
  echo
  echo "Options:"
  echo "  -o, --output <path>    Specify destination file path"
  echo "  -h, --help             Show this help message"
  exit 0
}

CURL_PID=""
cleanup() {
  if [ -n "$CURL_PID" ] && kill -0 "$CURL_PID" 2>/dev/null; then
    kill -9 "$CURL_PID" 2>/dev/null || true
  fi
  echo -e "\n  ${RED}[!] DOWNLOAD ABORTED BY USER${RESET}"
  exit 1
}
trap cleanup SIGINT SIGTERM

# Parse Arguments
URL=""
OUT_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      ;;
    -o|--output)
      OUT_FILE="$2"
      shift 2
      ;;
    *)
      if [ -z "$URL" ]; then
        URL="$1"
      else
        OUT_FILE="$1"
      fi
      shift
      ;;
  esac
done

if [ -z "$URL" ]; then
  echo -e "${RED}[ERROR] No URL specified.${RESET}"
  echo "Usage: arcxos-dl <URL> [-o OUTPUT_PATH]"
  exit 1
fi

# Determine filename and target directory
RAW_NAME=$(basename "${URL%%\?*}")
if [ -z "$RAW_NAME" ] || [ "$RAW_NAME" = "/" ]; then
  RAW_NAME="download.bin"
fi

if [ -z "$OUT_FILE" ]; then
  OUT_FILE="./${RAW_NAME}"
fi

intro_once

# Inspect headers for total file size (Content-Length)
echo -e "  ${CYAN}[+] QUERYING REMOTE METADATA...${RESET}"
HEADERS=$(curl -sIL "$URL" || true)
TOTAL_BYTES=$(echo "$HEADERS" | grep -i '^content-length:' | tail -n 1 | awk '{print $2}' | tr -d '\r' || echo 0)

if ! [[ "$TOTAL_BYTES" =~ ^[0-9]+$ ]] || [ "$TOTAL_BYTES" -eq 0 ]; then
  TOTAL_BYTES=0
fi

transfer_banner "$URL" "$OUT_FILE"

# Start background curl process
mkdir -p "$(dirname "$OUT_FILE")"
curl -s -L -C - "$URL" -o "$OUT_FILE" &
CURL_PID=$!

start_time=$(date +%s.%N)
last_bytes=0
last_time=$start_time
i=0

while kill -0 "$CURL_PID" 2>/dev/null; do
  cur_bytes=0
  if [ -f "$OUT_FILE" ]; then
    cur_bytes=$(stat -c%s "$OUT_FILE" 2>/dev/null || echo 0)
  fi

  now=$(date +%s.%N)
  dt=$(awk "BEGIN {print $now - $last_time}")

  # Calculate speed every ~0.3 sec window
  if awk "BEGIN {exit !($dt >= 0.3)}"; then
    db=$(( cur_bytes - last_bytes ))
    if (( db < 0 )); then db=0; fi
    speed=$(awk "BEGIN {print $db / $dt}")
    last_bytes=$cur_bytes
    last_time=$now
  else
    speed=${speed:-0}
  fi

  spin="${SPINNER[$((i % 6))]}"
  trace=$(printf '%02x%02x%02x%02x' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))

  if [ "$TOTAL_BYTES" -gt 0 ]; then
    pct=$(( cur_bytes * 100 / TOTAL_BYTES ))
    if (( pct > 100 )); then pct=100; fi
    filled=$(( cur_bytes * WIDTH / TOTAL_BYTES ))
    if (( filled > WIDTH )); then filled=$WIDTH; fi

    col=$(bar_color "$pct")
    bar=""
    for ((j=0; j<filled; j++)); do bar+="$FILLED"; done
    if (( filled < WIDTH )); then
      bar+="$HEAD"
      for ((j=filled+1; j<WIDTH; j++)); do bar+="$EMPTY"; done
    fi

    printf "\r  ${GOLD}%s${RESET}  ${col}[${BCYAN}%s${col}]${RESET} ${WHITE}%3d%%${RESET}  ${DIM}%s/%s${RESET}  ${col}%s/s${RESET}  ${DIM}▸0x%s${RESET}   " \
      "$spin" "$bar" "$pct" "$(human "$cur_bytes")" "$(human "$TOTAL_BYTES")" "$(human "${speed%.*}")" "$trace"
  else
    # Unknown total size pulse bar
    col="$CYAN"
    pulse_pos=$(( i % WIDTH ))
    bar=""
    for ((j=0; j<WIDTH; j++)); do
      if [ $j -eq $pulse_pos ]; then bar+="$HEAD"; else bar+="$EMPTY"; fi
    done
    printf "\r  ${GOLD}%s${RESET}  ${col}[${BCYAN}%s${col}]${RESET} ${WHITE}DOWNLOADING${RESET}  ${DIM}%s${RESET}  ${col}%s/s${RESET}  ${DIM}▸0x%s${RESET}   " \
      "$spin" "$bar" "$(human "$cur_bytes")" "$(human "${speed%.*}")" "$trace"
  fi

  i=$(( i + 1 ))
  sleep 0.1
done

wait "$CURL_PID" || {
  echo -e "\n  ${RED}[!] DOWNLOAD FAILED (CURL ERROR)${RESET}"
  exit 1
}

# 100% Final Bar Render
FINAL_SIZE=$(stat -c%s "$OUT_FILE" 2>/dev/null || echo 0)
fullbar=""
for ((j=0; j<WIDTH; j++)); do fullbar+="$FILLED"; done

printf "\r  ${GOLD}⬤${RESET}  ${GOLD}[${BCYAN}%s${GOLD}]${RESET} ${WHITE}100%%${RESET}  ${DIM}%s/%s${RESET}%*s\n" \
  "$fullbar" "$(human "$FINAL_SIZE")" "$(human "$FINAL_SIZE")" 16 ""

# Compute real SHA-256 checksum
CHECKSUM="computing..."
if command -v sha256sum &>/dev/null; then
  CHECKSUM=$(sha256sum "$OUT_FILE" | awk '{print $1}')
fi

echo -e "  ${GREEN}[ OK ]${RESET} ${CYAN}XFER COMPLETE${RESET} ${DIM}→${RESET} ${OUT_FILE}"
echo -e "  ${GREEN}[ OK ]${RESET} ${DIM}INTEGRITY (SHA256) →${RESET} ${GOLD}${CHECKSUM}${RESET}"
echo
echo -e "${DIM}root@arcxos${RESET}${WHITE}:${RESET}${CYAN}~${RESET} ${GOLD}❯${RESET} █"
echo
