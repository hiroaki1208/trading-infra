# プロジェクト設定
project_id = "trading-prod-468212"
region     = "asia-northeast1"

# Cloud Run Job 設定
job_name        = "hello-world-daily-job"
container_image = "asia-northeast1-docker.pkg.dev/trading-prod-468212/trading-infra/hello-world:latest"

# リソース制限
cpu_limit    = "1"
memory_limit = "512Mi"

# ジョブ実行設定
max_retries  = 3
parallelism  = 1
task_count   = 1
task_timeout = "3600s"

# サービスアカウント（適切なサービスアカウントのメールアドレスに変更してください）
service_account_email = "cloud-run-service@trading-prod-468212.iam.gserviceaccount.com"

# 環境変数（必要に応じて設定）
environment_variables = {
  ENV_NAME  = "production"
  LOG_LEVEL = "info"
}

# Cloud Scheduler 設定
scheduler_name        = "hello-world-daily-scheduler"
scheduler_description = "Daily execution of hello-world Cloud Run job"
schedule_cron         = "0 9 * * *" # 毎日9時（JST）
time_zone             = "Asia/Tokyo"

# スケジューラーのリトライ設定
attempt_deadline     = "320s"
retry_count          = 1
max_retry_duration   = "0s"
max_backoff_duration = "3600s"
max_doublings        = 16
