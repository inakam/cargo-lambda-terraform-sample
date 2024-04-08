variable "function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "role" {
  description = "The ARN of the IAM role to be used by Lambda function."
  type        = string
}

variable "environment_variables" {
  description = "A map of environment variables to pass to the Lambda function."
  type        = map(string)
  default     = {}
}

variable "rust_src_path" {
  description = "The path to the Lambda function's Rust project."
  type        = string
}

variable "cargo_lambda_env_name" {
  description = "name in cargo lambda new [name]"
  type        = string
}

variable "lambda_zip_local_path" {
  description = "The path where the Lambda function's zip archive will be saved."
  type        = string
}

