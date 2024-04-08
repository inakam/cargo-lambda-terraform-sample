module "api_lambda" {
  source = "./modules/rust_lambda_module"

  function_name = "${var.name}-api"
  role          = aws_iam_role.lambda_iam_role.arn

  rust_src_path         = "../rust-lambda"
  cargo_lambda_env_name = "rust-lambda"
  lambda_zip_local_path = "../lambda_archive/api.zip"

  environment_variables = {
    RUST_BACKTRACE            = 1
  }
}

