# 基本設定変数
variable "project_id" {
  description = "Google Cloud プロジェクトID"
  type        = string
}

variable "region" {
  description = "リソースを作成するリージョン"
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

# Cloud Run Job 設定
variable "job_name" {
  description = "Cloud Run Jobの名前"
  type        = string
  default     = "hello-world-daily-job"
}

variable "container_image" {
  description = "実行するコンテナイメージのURL（Artifact Registry）"
  type        = string
}

variable "cpu_limit" {
  description = "CPUの制限"
  type        = string
  default     = "1"
}

variable "memory_limit" {
  description = "メモリの制限"
  type        = string
  default     = "512Mi"
}

variable "max_retries" {
  description = "最大リトライ回数"
  type        = number
  default     = 3
}

variable "parallelism" {
  description = "並列実行数"
  type        = number
  default     = 1
}

variable "task_count" {
  description = "実行するタスク数"
  type        = number
  default     = 1
}

variable "task_timeout" {
  description = "タスクのタイムアウト時間"
  type        = string
  default     = "3600s"
}

# 環境識別変数
variable "environment" {
  description = "環境名（dev, prod）"
  type        = string
}

# Dev環境用サービスアカウント
variable "dev_run_service_account_email" {
  description = "Dev環境でCloud Run Jobで使用するサービスアカウントのメールアドレス（ランタイム用）"
  type        = string
  default     = ""
}

variable "dev_scheduler_service_account_email" {
  description = "Dev環境でCloud Schedulerで使用するサービスアカウントのメールアドレス（OAuthトークン発行用）"
  type        = string
  default     = ""
}

# Prod環境用サービスアカウント
variable "prod_run_service_account_email" {
  description = "Prod環境でCloud Run Jobで使用するサービスアカウントのメールアドレス（ランタイム用）"
  type        = string
  default     = ""
}

variable "prod_scheduler_service_account_email" {
  description = "Prod環境でCloud Schedulerで使用するサービスアカウントのメールアドレス（OAuthトークン発行用）"
  type        = string
  default     = ""
}

# 実際に使用するサービスアカウント（環境に基づいて決定）
locals {
  run_service_account_email       = var.environment == "dev" ? var.dev_run_service_account_email : var.prod_run_service_account_email
  scheduler_service_account_email = var.environment == "dev" ? var.dev_scheduler_service_account_email : var.prod_scheduler_service_account_email
}

variable "environment_variables" {
  description = "コンテナに設定する環境変数"
  type        = map(string)
  default     = {}
}

# Cloud Scheduler 設定
variable "scheduler_name" {
  description = "Cloud Schedulerジョブの名前"
  type        = string
  default     = "hello-world-daily-scheduler"
}

variable "scheduler_description" {
  description = "Cloud Schedulerジョブの説明"
  type        = string
  default     = "Daily execution of hello-world Cloud Run job"
}

variable "schedule_cron" {
  description = "スケジュール実行のcron式（毎日実行）"
  type        = string
  default     = "0 9 * * *" # 毎日9時（JST）
}

variable "time_zone" {
  description = "スケジュールのタイムゾーン"
  type        = string
  default     = "Asia/Tokyo"
}

variable "attempt_deadline" {
  description = "試行の最大実行時間"
  type        = string
  default     = "320s"
}

variable "retry_count" {
  description = "リトライ回数"
  type        = number
  default     = 1
}

variable "max_retry_duration" {
  description = "最大リトライ期間"
  type        = string
  default     = "0s"
}

variable "max_backoff_duration" {
  description = "最大バックオフ期間"
  type        = string
  default     = "3600s"
}

variable "max_doublings" {
  description = "最大ダブリング回数"
  type        = number
  default     = 16
}
