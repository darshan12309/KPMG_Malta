#!/bin/bash

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/[a-z]$//')

METADATA=$(aws ec2 describe-instances --region $REGION --instance-ids $INSTANCE_ID --query 'Reservations[*].Instances[*]' --output json)

echo $METADATA
