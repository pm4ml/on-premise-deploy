#!/bin/bash

echo "Making 4 requests with 1 second delay between each..."
echo "Expected: First 3 requests should succeed, last 1 should be rate limited"

# for i in {1..5}; do
#     echo -n "Request $i: "
#     curl -v -H "Host: localhost:8080" http://localhost:8080 2>&1 | grep "< HTTP"
#     if [ $i -lt 5 ]; then
#         sleep 0.2
#     fi
# done 

for i in {1..4}; do curl -I --header "Host: ratelimit.example" --header "x-user-id: one" http://localhost:8080 ; sleep 1; done
