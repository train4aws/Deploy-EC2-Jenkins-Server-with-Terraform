resource "aws_iam_role" "IAM-Jenkins-S3-Access" {
  name = "IAM-Jenkins-S3-Access"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3-jenkins-rw-policy" {
  name   = "IAM-Jenkins-S3-Access"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3ReadWriteAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${var.bucket}",
        "arn:aws:s3:::${var.bucket}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3-jenkins-s3-access" {
  policy_arn = aws_iam_policy.IAM-Jenkins-S3-Access.arn
  role       = IAM-Jenkins-S3-Access.name
}

resource "aws_iam_instance_profile" "IAM-Jenkins-S3-Access-profile" {
  name = "IAM-Jenkins-S3-Access-profile"
  role = IAM-Jenkins-S3-Access.name
}
