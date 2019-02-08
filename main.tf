provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.s3_bucket_name}"
  acl    = "private"
}

resource "aws_s3_bucket_object" "object" {
  bucket = "${aws_s3_bucket.bucket.id}"
  key = "deployment.zip"
  source = "${path.module}/deployment.zip"
  etag = "${md5(file("${path.module}/deployment.zip"))}"
}

resource "aws_iam_role" "lambda_role" {
  name = "FibonnaciFunctionRole"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_lambda_function" "function" {
  filename      = "deployment.zip"
  function_name = "Fibonacci"
  role          = "${aws_iam_role.lambda_role.arn}"
  handler       = "main"
  runtime       = "go1.x"
}