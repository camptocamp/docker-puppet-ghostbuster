#!/bin/bash

url="$API_BASE_URL/repos/$REPO_OWNER/$REPO_NAME/issues?token=$TOKEN"

echo "[*] Retrieving issues..."
issues=""
i=0
while true; do
  i=$((i + 1))
  data=$(curl -s -q "$url&page=$i" | jq -r ".[].title" )
  if [ -n "$data" ]; then
    issues=$(echo -e "$issues\n$data")
  else
    break
  fi
done

echo "[*] Looking for new issues..."

while read line; do
  exists=0
  title=$(echo "$line" | jq -r ".title")

  while read issue; do
    if [ "$issue" = "$title" ]; then
      exists=1
      break
    fi
  done <<< "$issues"

  if [[ $exists -eq 0 ]]; then
    curl -s -q -H 'Content-Type: application/json' "$url" -d "$line"
  fi
done < "${1:-/dev/stdin}"

echo "[+] Operation successfully completed."
