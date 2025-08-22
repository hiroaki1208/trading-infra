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
  name          = var.bucket_name
  location      = var.location
  project       = var.project_id
  force_destroy = var.force_destroy

  # バージョニングの設定
  versioning {
    enabled = var.versioning_enabled
  }

  # パブリックアクセス防止
  public_access_prevention = "enforced"
}

# バケットへのIAMアクセス権管理
# 例：Storage Object Viewer権限をサービスアカウントに付与
resource "google_storage_bucket_iam_binding" "bucket_object_viewer" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"

  members = var.object_viewers
}

# 例：Storage Object Admin権限をサービスアカウントに付与
resource "google_storage_bucket_iam_binding" "bucket_object_admin" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectAdmin"

  members = var.object_admins
}

# 例：Storage Admin権限をサービスアカウントに付与
resource "google_storage_bucket_iam_binding" "bucket_admin" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.admin"

  members = var.bucket_admins
}
