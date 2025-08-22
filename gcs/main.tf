# Terraformの設定ブロック
# このプロジェクトで使用するTerraformのバージョンとプロバイダーを定義
terraform {
  # 必要なTerraformのバージョンを指定（1.6.0以上）
  required_version = ">= 1.6.0"

  # 使用するプロバイダーとそのバージョンを指定
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40"
    }
  }
}

# Google Cloudプロバイダーの設定
# 接続先のプロジェクトとリージョンを指定
provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = var.google_credentials
}

# Google Cloud Storage バケットの作成
resource "google_storage_bucket" "bucket" {
  name          = "${var.bucket_name}-${var.environment}"
  location      = var.location
  project       = var.project_id
  force_destroy = var.force_destroy

  # バージョニングの設定
  versioning {
    enabled = var.versioning_enabled
  }

  # パブリックアクセス防止
  public_access_prevention = "enforced"

  # ライフサイクル設定で既存リソースとの競合を回避
  lifecycle {
    # バケット名の変更を無視（既存バケットがある場合）
    ignore_changes = [name]
    # リソースの破棄を防止
    prevent_destroy = false
  }
}
