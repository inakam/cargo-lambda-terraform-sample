# rust-lambda

Terraformを用いてRust言語でAWS Lambdaをデプロイするための簡単なテンプレートです。

# 使い方

## 1. cargo-lambdaのインストール

- Macの場合
    ```bash
    $ brew tap cargo-lambda/cargo-lambda
    $ brew install cargo-lambda
    ```

- そのほかのシステムにおいては、以下を参考にインストールしてください
  - https://www.cargo-lambda.info/guide/installation.html

## 2. プロジェクトのクローン

```bash
$ git clone https://github.com/inakam/cargo-lambda-terraform-sample.git
$ cd terraform
```

## 3. 設定の修正

- terraform/variables.tf の AWSプロファイル名をローカル環境のものなどに修正します

## 4. デプロイ

- terraformフォルダ内でapplyを行うことで、Lambda関数がデプロイされます

```bash
$ terraform init
$ terraform apply
```
