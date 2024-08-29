# Define the AWS region
variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = ""
}

# Define the SNS FIFO topic name
variable "sns_topic_name" {
  description = "The name of the SNS FIFO topic"
  type        = string
  default     = ""
}

# Define the SQS queue name
variable "sqs_queue_name" {
  description = "The name of the SQS FIFO queue"
  type        = string
  default     = ""
}
