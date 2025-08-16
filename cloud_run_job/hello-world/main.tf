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

# Cloud Run APIの有効化
# Cloud Run Jobsを使用するために必要なAPIサービスを有効にする
resource "google_project_service" "cloud_run" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

# Cloud Scheduler APIの有効化
# 定期実行のスケジューリングに必要なAPIサービスを有効にする
resource "google_project_service" "cloud_scheduler" {
  project            = var.project_id
  service            = "cloudscheduler.googleapis.com"
  disable_on_destroy = false
}

# Cloud Run Job の作成
# Artifact Registryからhello-worldイメージを使用してジョブを定義
resource "google_cloud_run_v2_job" "hello_world_job" {
  name     = var.job_name
  location = var.region

  template {
    # テンプレートレベルの設定
    task_count  = var.task_count
    parallelism = var.parallelism

    template {
      # 実行するコンテナの設定
      containers {
        image = var.container_image

        # リソース制限の設定
        resources {
          limits = {
            cpu    = var.cpu_limit
            memory = var.memory_limit
          }
        }

        # 環境変数の設定（必要に応じて）
        dynamic "env" {
          for_each = var.environment_variables
          content {
            name  = env.key
            value = env.value
          }
        }
      }

      # ジョブの実行設定
      max_retries     = var.max_retries
      timeout         = var.task_timeout   # 例: "3600s"
      service_account = var.service_account_email
    }
  }

  # 依存関係の定義
  depends_on = [
    google_project_service.cloud_run
  ]
}

# Cloud Scheduler Job の作成
# 毎日定期実行するためのスケジューラーを設定
resource "google_cloud_scheduler_job" "hello_world_scheduler" {
  name             = var.scheduler_name
  description      = var.scheduler_description
  schedule         = var.schedule_cron
  time_zone        = var.time_zone
  region           = var.region
  attempt_deadline = var.attempt_deadline

  retry_config {
    retry_count          = var.retry_count
    max_retry_duration   = var.max_retry_duration
    max_backoff_duration = var.max_backoff_duration
    max_doublings        = var.max_doublings
  }

  http_target {
    http_method = "POST"
    uri         = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${google_cloud_run_v2_job.hello_world_job.name}:run"

    headers = {
      "Content-Type" = "application/json"
    }

    oauth_token {
      service_account_email = var.service_account_email
    }
  }

  # 依存関係の定義
  depends_on = [
    google_project_service.cloud_scheduler,
    google_cloud_run_v2_job.hello_world_job
  ]
}
