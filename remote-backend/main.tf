resource "aws_s3_bucket" "statefile_bucket" {
  bucket = var.statefile
}

resource "aws_dynamodb_table" "statelock_table" {
  name     = var.statefile
  hash_key = var.key
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = var.key
    type = "S"
  }
}
