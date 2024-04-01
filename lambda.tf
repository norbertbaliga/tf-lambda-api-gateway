# Archive the lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/hello-world"
  output_path = "${path.module}/dist/hello-world.zip"
}

# Upload the lambda function archive to the bucket
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "hello-world/hello-world.zip"

  source = data.archive_file.lambda_zip.output_path
  etag   = filemd5(data.archive_file.lambda_zip.output_path)
}

# Create the lambda function
resource "aws_lambda_function" "hello_world" {
  function_name = "hello-world"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_zip.key

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  handler = "hello-world.handler"
  runtime = "nodejs20.x"

  role = aws_iam_role.lambda_exec.arn
}

# Give API Gateway permission to invoke the lambda function
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}