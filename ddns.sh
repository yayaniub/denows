#!/bin/sh
ZONE_ID="af31a1a2c32023a30322604c3dc21767"
API_TOKEN="9ilmrV3EWC0xET59xj140SoakfohM_NUXb9_gJzl"
curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
     -H "Authorization: Bearer '$API_TOKEN'" \
     -H "Content-Type: application/json"
