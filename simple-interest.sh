#!/usr/bin/env bash
set -euo pipefail

print_usage() {
  cat <<EOF
Usage:
  $0 -p PRINCIPAL -r RATE -t TIME
Options:
  -p PRINCIPAL   Principal amount (required)
  -r RATE        Annual interest rate (percent) (required)
  -t TIME        Time in years (required)
  -h             Show this help / interactive mode

Examples:
  $0 -p 1000 -r 5 -t 2
  $0             # runs interactive prompts
EOF
}

# Parse args
P=""
R=""
T=""

while getopts "p:r:t:h" opt; do
  case "$opt" in
    p) P="$OPTARG" ;;
    r) R="$OPTARG" ;;
    t) T="$OPTARG" ;;
    h) print_usage; exit 0 ;;
    *) print_usage; exit 1 ;;
  esac
done

# If none provided, run interactive prompts
if [[ -z "$P" && -z "$R" && -z "$T" ]]; then
  echo "Interactive mode: enter values or press Enter to cancel."
  read -rp "Principal amount (e.g. 1000): " P
  read -rp "Annual interest rate in % (e.g. 5): " R
  read -rp "Time in years (e.g. 2): " T
fi

# Validate
if [[ -z "$P" || -z "$R" || -z "$T" ]]; then
  echo "Error: principal, rate and time are required."
  print_usage
  exit 2
fi

# Use bc for decimal arithmetic
# scale=4 for internal precision, format to 2 decimals for output
SI=$(echo "scale=6; ($P * $R * $T) / 100" | bc -l)
TOTAL=$(echo "scale=6; $P + $SI" | bc -l)

# Format to 2 decimal places
SI_FMT=$(printf "%.2f" "$SI")
TOTAL_FMT=$(printf "%.2f" "$TOTAL")

echo "Simple Interest: $SI_FMT"
echo "Total Amount (Principal + Interest): $TOTAL_FMT"
