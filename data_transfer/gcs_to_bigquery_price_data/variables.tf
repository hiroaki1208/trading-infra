# 必須変数
variable "project_id" {
  description = "Google Cloud プロジェクトID"
  type        = string
}

variable "region" {
  description = "リージョン"
  type        = string
  default     = "asia-northeast1"
}

variable "location" {
  description = "BigQuery のリージョン/マルチリージョン"
  type        = string
  default     = "asia-northeast1"
}

# Google Cloud認証情報
variable "google_credentials" {
  description = "Google Cloud サービスアカウントキー（JSON文字列）"
  type        = string
  default     = null
  sensitive   = true
}

# 環境識別変数
variable "environment" {
  description = "環境名（dev, prod）"
  type        = string
}

# Dev環境用サービスアカウント
variable "dev_data_transfer_service_account_email" {
  description = "Dev環境でBigQuery Data Transferで使用するサービスアカウントのメールアドレス"
  type        = string
  default     = "bq-transfer-runner-dev@trading-dev-469206.iam.gserviceaccount.com"
}

# Prod環境用サービスアカウント
variable "prod_data_transfer_service_account_email" {
  description = "Prod環境でBigQuery Data Transferで使用するサービスアカウントのメールアドレス"
  type        = string
  default     = "bq-transfer-runner-prod@trading-prod-468212.iam.gserviceaccount.com"
}

# BigQuery設定
variable "dataset_id" {
  description = "BigQueryデータセットID"
  type        = string
  default     = "trading"
}

variable "table_id" {
  description = "BigQueryテーブルID"
  type        = string
  default     = "price_data"
}

# GCS設定
variable "bucket_name_base" {
  description = "GCSバケット名のベース部分"
  type        = string
  default     = "takotako-ikaika-trading-a1b2c3"
}

variable "gcs_source_path" {
  description = "GCS内のソースファイルパス"
  type        = string
  default     = "price_data/fetch_at_*.csv"
}

# Data Transfer Service設定
variable "transfer_display_name" {
  description = "Data Transfer Serviceの表示名"
  type        = string
  default     = "Price Data GCS to BigQuery Transfer"
}

variable "schedule_time" {
  description = "スケジュール実行時間（24時間形式）"
  type        = string
  default     = "15:00"
}

variable "time_zone" {
  description = "タイムゾーン"
  type        = string
  default     = "Asia/Tokyo"
}

# 使用するバケット名とサービスアカウント（環境に基づいて決定）
locals {
  bucket_name                         = "${var.bucket_name_base}-${var.environment}"
  source_uris                         = "gs://${local.bucket_name}/${var.gcs_source_path}"
  data_transfer_service_account_email = var.environment == "dev" ? var.dev_data_transfer_service_account_email : var.prod_data_transfer_service_account_email
}

# BigQueryテーブルのスキーマ定義
variable "table_schema" {
  description = "BigQueryテーブルのスキーマ定義"
  type = list(object({
    name        = string
    type        = string
    mode        = string
    description = string
  }))
  default = [
    {
      name        = "date"
      type        = "DATE"
      mode        = "NULLABLE"
      description = "取引日"
    },
    {
      name        = "ticker"
      type        = "STRING"
      mode        = "NULLABLE"
      description = "ティッカーシンボル"
    },
    {
      name        = "ohlc_type"
      type        = "STRING"
      mode        = "NULLABLE"
      description = "OHLC種別（open, high, low, close）"
    },
    {
      name        = "price"
      type        = "FLOAT"
      mode        = "NULLABLE"
      description = "価格"
    },
    {
      name        = "fetch_time_str"
      type        = "STRING"
      mode        = "NULLABLE"
      description = "データ取得時刻_文字列(%Y-%m-%d %H:%M:%S)"
    }
  ]
}
