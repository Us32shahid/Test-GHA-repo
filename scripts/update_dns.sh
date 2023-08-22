#!/bin/bash

# Variables
API_KEY="HsoabgfSbNQVeHpg30hI14GOo8mZLixzk_7HhJY8"
DOMAIN="karazo.com"
RECORD_NAME="usama.karazo.com"
COMMENT_FILE="comment.txt"
LOG_FILE="log.txt"

# Load previous comment or initialize if not exists
if [ -f "$COMMENT_FILE" ]; then
  COMMENT=$(cat "$COMMENT_FILE")
else
  COMMENT=1
fi

# Update the comment
COMMENT=$((COMMENT + 1))
echo "$COMMENT" > "$COMMENT_FILE"

# Check if the DNS record exists
RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/records?domain=$DOMAIN&name=$RECORD_NAME" -H "Authorization: Bearer $API_KEY" | jq -r '.[0].id')

# Create or update the DNS record
if [ -z "$RECORD_ID" ]; then
  # Create record
  curl -X POST "https://api.cloudflare.com/records" -H "Authorization: Bearer $API_KEY" -d "domain=$DOMAIN&name=$RECORD_NAME&comment=$COMMENT"
  echo "Record created with comment $COMMENT" >> "$LOG_FILE"
else
  # Update record
  curl -X PUT "https://api.cloudflare.com/records/$RECORD_ID" -H "Authorization: Bearer $API_KEY" -d "comment=$COMMENT"
  echo "Record updated with comment $COMMENT" >> "$LOG_FILE"
fi

# Send email notification
echo "DNS Record updated with comment $COMMENT" | mail -s "DNS Record Update" us323619@gmail.com
