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

# Google Cloudプロバイダー
provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = var.google_credentials
}

# 必要APIの有効化
resource "google_project_service" "cloud_run" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloud_scheduler" {
  project            = var.project_id
  service            = "cloudscheduler.googleapis.com"
  disable_on_destroy = false
}

# Cloud Run Job
resource "google_cloud_run_v2_job" "hello_world_job" {
  name     = var.job_name
  location = var.region

  template {
    task_count  = var.task_count
    parallelism = var.parallelism

    template {
      containers {
        image = local.container_image

        resources {
          limits = {
            cpu    = var.cpu_limit
            memory = var.memory_limit
          }
        }

        dynamic "env" {
          for_each = var.environment_variables
          content {
            name  = env.key
            value = env.value
          }
        }
      }

      # ← 実行用サービスアカウント（ランタイム）
      service_account = local.run_service_account_email

      max_retries = var.max_retries
      timeout     = var.task_timeout
    }
  }

  depends_on = [
    google_project_service.cloud_run
  ]
}

# Cloud Scheduler Job
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
    uri         = "https://run.googleapis.com/v2/projects/${var.project_id}/locations/${var.region}/jobs/${google_cloud_run_v2_job.hello_world_job.name}:run"


    headers = {
      "Content-Type" = "application/json"
    }

    # ← 起動用サービスアカウント（OAuthトークン発行に使用）
    oauth_token {
      service_account_email = local.scheduler_service_account_email
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
    }
  }

  depends_on = [
    google_project_service.cloud_scheduler,
    google_cloud_run_v2_job.hello_world_job
  ]
}
