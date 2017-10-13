#!/bin/bash

url="$API_BASE_URL/repos/$REPO_OWNER/$REPO_NAME/issues?token=$TOKEN"

issues=$(curl -q "$url" | jq -r ".[].title" )

while read line; do
  exists=0
  title=$(echo "$line" | jq -r ".title")

  while read issue; do
    if [ "$issue" = "$title" ]; then
      exists=1
    fi
  done <<< "$issues"

  if [[ $exists -eq 0 ]]; then
    curl -q -H 'Content-Type: application/json' "$url" -d "$line"
  fi
done < "${1:-/dev/stdin}"
