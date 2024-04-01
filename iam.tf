# Create the IAM role for the lambda function
resource "aws_iam_role" "lambda_exec" {
  name = "terraform-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the AWS managed policy for lambda execution
resource "aws_iam_policy_attachment" "lambda_exec_policy" {
  name       = "terraform-lambda-exec-policy"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}