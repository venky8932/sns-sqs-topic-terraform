#!/usr/bin/env bash

# Get the AWS caller identity
aws sts get-caller-identity

# Set environment variable for the environment-specific
ENVIRONMENT="int"

# Get the current Terraform workspace
CURRENT_WORKSPACE=$(terraform workspace show)

# Define an associative array of secret names based on the workspace
declare -A SECRET_NAMES
SECRET_NAMES["int"]=("osnd" "apif")
SECRET_NAMES["prod"]=("osnd" "apif")  # Add more as needed for different environments

# Check if the current workspace has defined secret names
if [[ -v SECRET_NAMES[$CURRENT_WORKSPACE] ]]; then
    # Loop through each secret name to initialize Terraform
    for secret_name in "${SECRET_NAMES[$CURRENT_WORKSPACE][@]}"; do
        echo "Initializing Terraform for secret: ${secret_name}"

        # Initialize the Terraform S3 backend with a unique state file for each app
        terraform init \
            -backend-config "key=bm/${ENVIRONMENT}/${secret_name}-${ENVIRONMENT}-secrets.tfstate" \
            -backend-config "region=us-east-1" \
            -backend-config "dynamodb_table=vz-vss-us-east-1-af-asf-state-lock-dynamodb" \
            -backend-config "bucket=vz-vss-us-east-1-nan-prod-af-asf-terraform-state" \
            -reconfigure \
            -input=false

        echo "Terraform initialized for secret: ${secret_name} with state file: ${secret_name}-${ENVIRONMENT}-secrets.tfstate"
    done
else
    echo "No secrets defined for the current workspace: ${CURRENT_WORKSPACE}"
    exit 1
fi
