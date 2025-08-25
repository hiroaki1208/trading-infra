# Terraformの設定ブロック
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40"
    }
  }
}

# Google Cloudプロバイダーの設定
provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = var.google_credentials
}

# 必要なAPIサービスの有効化
resource "google_project_service" "bigquery" {
  project            = var.project_id
  service            = "bigquery.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "bigquerydatatransfer" {
  project            = var.project_id
  service            = "bigquerydatatransfer.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "storage" {
  project            = var.project_id
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}

# BigQueryテーブルの作成
resource "google_bigquery_table" "price_data" {
  project             = var.project_id
  dataset_id          = var.dataset_id
  table_id            = var.table_id
  deletion_protection = false

  # テーブルスキーマの定義
  schema = jsonencode(var.table_schema)

  # 既存のデータセットに依存
  depends_on = [
    google_project_service.bigquery
  ]

  lifecycle {
    # テーブルが既に存在する場合は無視
    ignore_changes = [schema]
  }
}

# BigQuery Data Transfer Serviceの設定
resource "google_bigquery_data_transfer_config" "gcs_to_bigquery" {
  display_name   = "${var.transfer_display_name} (${var.environment})"
  location       = var.location
  data_source_id = "google_cloud_storage"

  # 転送先テーブルの設定
  destination_dataset_id = var.dataset_id

  # スケジュール設定（毎日15時JST）
  schedule = "every day ${var.schedule_time}"

  # データソース固有のパラメータ
  params = {
    data_path_template              = local.source_uris
    destination_table_name_template = var.table_id
    file_format                     = "CSV"
    max_bad_records                 = "0"
    skip_leading_rows               = "1"      # ヘッダー行をスキップ
    write_disposition               = "APPEND" # 既存データに追加
    field_delimiter                 = ","
    allow_quoted_newlines           = "false"
    allow_jagged_rows               = "false"
    encoding                        = "UTF-8"
  }

  # 通知設定（オプション）
  notification_pubsub_topic = null

  # サービスアカウント指定
  service_account_name = local.data_transfer_service_account_email

  depends_on = [
    google_project_service.bigquerydatatransfer,
    google_bigquery_table.price_data
  ]
}
