resource "aws_sns_topic" "sns_topic" {
  name = var.sns_topic_name

  fifo_topic = true
  content_based_deduplication = true
}

# Create an SQS FIFO queue
resource "aws_sqs_queue" "sqs_queue" {
  name = var.sqs_queue_name

  fifo_queue = true
  content_based_deduplication = true

  # Explicitly make sure the queue is created after the SNS topic
  depends_on = [aws_sns_topic.sns_topic]
}

# Create an SNS topic subscription to the SQS queue
resource "aws_sns_topic_subscription" "sns_to_sqs" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs_queue.arn

  # Policy to allow SNS to send messages to SQS
  depends_on = [aws_sqs_queue_policy.sqs_policy, aws_sns_topic.sns_topic]
}

# SQS queue policy to allow SNS to send messages
resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.sqs_queue.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "sqs:SendMessage",
        Resource = aws_sqs_queue.sqs_queue.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.sns_topic.arn
          }
        }
      }
    ]
  })

  depends_on = [aws_sns_topic.sns_topic]
}
