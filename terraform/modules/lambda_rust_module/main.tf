resource "aws_lambda_function" "this" {
  function_name = var.function_name

  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256

  role          = var.role
  architectures = ["arm64"]
  handler       = "bootstrap"
  runtime       = "provided.al2"

  timeout = 30

  environment {
    variables = var.environment_variables
  }
}

resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}

resource "null_resource" "rust_build" {
  triggers = {
    code_diff = sha512(join("", [
      for file in fileset(var.rust_src_path, "**/*.rs")
      : filesha256("${var.rust_src_path}/${file}")
    ]))
  }

  provisioner "local-exec" {
    working_dir = var.rust_src_path
    command     = "cargo lambda build --release --arm64"
  }
}

data "archive_file" "this" {
  type        = "zip"
  source_file = "${var.rust_src_path}/target/lambda/${var.cargo_lambda_env_name}/bootstrap"
  output_path = var.lambda_zip_local_path

  depends_on = [
    null_resource.rust_build
  ]
}

