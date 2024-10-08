
    # Initialize the Terraform S3 backend for the specific secret
    terraform init \
        -backend-config "key=bm/${ENVIRONMENT}/${secret_name}-secrets.tfstate
