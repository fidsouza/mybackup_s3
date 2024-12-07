provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "backup_content_files" {
  bucket = "backup-content-files"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Environment = "Production"
    Name        = "Backup Content Files"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.backup_content_files.id

  rule {
    id     = "Move-to-Glacier-and-Deep-Archive"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
    }

    noncurrent_version_transition {
      noncurrent_days = 180
      storage_class   = "DEEP_ARCHIVE"
    }
  }
}
