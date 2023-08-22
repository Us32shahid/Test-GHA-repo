name: Cloudflare DNS
on:
  push:
    branches:
      - dns-create-practice  # Adjust the branch name as needed
  workflow_dispatch:

jobs:
  create-or-update-dns-record:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Create or Update DNS Record
      run: |
        # Replace placeholders with your actual values
        CF_API_TOKEN="HsoabgfSbNQVeHpg30hI14GOo8mZLixzk_7HhJY8"
        ZONE_ID="38b42bfdb42dbe301b6b1a27b86ac939"
        RECORD_NAME="usama.karazo.com"
        RECORD_TYPE="CNAME"
        RECORD_CONTENT="192.168.132.194"  # Replace with your IP address
        TTL=3600
        DNS_COMMENT="Domain verification record"  # Your comment here

        # Construct the API URL
        API_URL="https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records"

        # Check if the DNS record already exists
        EXISTING_DNS_RECORD=$(curl -s -H "Authorization: Bearer $CF_API_TOKEN" "$API_URL?type=$RECORD_TYPE&name=$RECORD_NAME&content=$RECORD_CONTENT")

        # Create or update the DNS record
        if [[ "$EXISTING_DNS_RECORD" == "[]" ]]; then
          curl -X POST "$API_URL" \
               -H "Authorization: Bearer $CF_API_TOKEN" \
               -H "Content-Type: application/json" \
               --data "{
                 \"type\": \"$RECORD_TYPE\",
                 \"name\": \"$RECORD_NAME\",
                 \"content\": \"$RECORD_CONTENT\",
                 \"ttl\": $TTL,
                 \"comment\": \"$DNS_COMMENT\"
               }"
          echo "DNS record created."
        else
          DNS_RECORD_ID=$(echo "$EXISTING_DNS_RECORD" | jq -r '.result[0].id')
          curl -X PUT "$API_URL/$DNS_RECORD_ID" \
               -H "Authorization: Bearer $CF_API_TOKEN" \
               -H "Content-Type: application/json" \
               --data "{
                 \"type\": \"$RECORD_TYPE\",
                 \"name\": \"$RECORD_NAME\",
                 \"content\": \"$RECORD_CONTENT\",
                 \"ttl\": $TTL,
                 \"comment\": \"$DNS_COMMENT\"
               }"
          echo "DNS record updated."
        fi

    - name: Send Email
      run: |
        python email_sent.py     # Replace with your email script file name