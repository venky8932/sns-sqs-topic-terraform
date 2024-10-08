#!/usr/bin/env bash

# Get the AWS caller identity
aws sts get-caller-identity

# Set environment variable for the environment-specific
ENVIRONMENT="int"

# Define an array of secret names
SECRET_NAMES=("osnd" "apif")

# Initialize Terraform
terraform init \
    -backend-config "key=bm/${ENVIRONMENT}/<default-secret>-secrets.tfstate" \
    -backend-config "region=us-east-1" \
    -backend-config "dynamodb_table=vz-vss-us-east-1-af-asf-state-lock-dynamodb" \
    -backend-config "bucket=vz-vss-us-east-1-nan-prod-af-asf-terraform-state" \
    -reconfigure \
    -input=false

# Loop through each secret name to initialize Terraform
for secret_name in "${SECRET_NAMES[@]}"; do
    echo "Initializing Terraform for secret: ${secret_name}"

    # Create or select the workspace based on the secret name
    terraform workspace select "${secret_name}" || terraform workspace new "${secret_name}"

    # Initialize the Terraform S3 backend for the specific secret
    terraform init \
        -backend-config "key=bm/${ENVIRONMENT}/${secret_name}-secrets.tfstate" \
        -backend-config "region=us-east-1" \
        -backend-config "dynamodb_table=vz-vss-us-east-1-af-asf-state-lock-dynamodb" \
        -backend-config "bucket=vz-vss-us-east-1-nan-prod-af-asf-terraform-state" \
        -reconfigure \
        -input=false

    echo "Terraform initialized for secret: ${secret_name} in workspace: ${secret_name}"
done
