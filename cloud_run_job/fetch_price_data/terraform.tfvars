# プロジェクト設定 - 環境変数で上書きされる
region = "asia-northeast1"

# Cloud Run Job 設定
job_name             = "fetch_daily_data_yfinance"
container_image_dev  = "asia-northeast1-docker.pkg.dev/trading-dev-469206/trading/fetch_daily_data:latest"
container_image_prod = "asia-northeast1-docker.pkg.dev/trading-prod-468212/trading/fetch_daily_data:latest"

# リソース制限
cpu_limit    = "1"
memory_limit = "512Mi"

# ジョブ実行設定
max_retries  = 3
parallelism  = 1
task_count   = 1
task_timeout = "3600s"

# サービスアカウント - Dev環境用
dev_run_service_account_email       = "crj-trading-rt-dev@trading-dev-469206.iam.gserviceaccount.com"
dev_scheduler_service_account_email = "cs-trading-inv-dev@trading-dev-469206.iam.gserviceaccount.com"

# サービスアカウント - Prod環境用
prod_run_service_account_email       = "crj-trading-rt-prod@trading-prod-468212.iam.gserviceaccount.com"
prod_scheduler_service_account_email = "cs-trading-inv-prod@trading-prod-468212.iam.gserviceaccount.com"

# 環境変数（必要に応じて設定）
environment_variables = {
  ENV_NAME  = "production"
  LOG_LEVEL = "info"
}

# Cloud Scheduler 設定
scheduler_name        = "fetch_daily_data_yfinance-scheduler"
scheduler_description = "Daily execution of fetch daily data from yfinance Cloud Run job"
schedule_cron         = "22 * * * *" # JST7:00
time_zone             = "Asia/Tokyo"

# スケジューラーのリトライ設定
attempt_deadline     = "320s"
retry_count          = 1
max_retry_duration   = "0s"
max_backoff_duration = "3600s"
max_doublings        = 16