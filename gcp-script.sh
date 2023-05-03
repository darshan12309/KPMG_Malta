#!/bin/bash

# get instance name from metadata server
INSTANCE_NAME=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/name")

# get instance metadata
METADATA=$(curl -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/?recursive=true&alt=json")

# output metadata in JSON format
echo "$METADATA" | jq .
