# 必須変数
variable "project_id" {
  description = "Google Cloud プロジェクトID"
  type        = string
}

variable "bucket_name" {
  description = "GCSバケット名（グローバルでユニークである必要がある）"
  type        = string
}

# オプション変数（デフォルト値あり）
variable "region" {
  description = "リージョン"
  type        = string
  default     = "asia-northeast1"
}

variable "location" {
  description = "バケットのロケーション"
  type        = string
  default     = "asia-northeast1"
}

variable "versioning_enabled" {
  description = "バージョニングを有効にするかどうか"
  type        = bool
  default     = false
}

variable "force_destroy" {
  description = "バケット内にオブジェクトがあってもバケットを削除するかどうか"
  type        = bool
  default     = false
}

# Google Cloud認証情報
variable "google_credentials" {
  description = "Google Cloud サービスアカウントキー（JSON文字列）"
  type        = string
  default     = null
  sensitive   = true
}

# IAMアクセス権設定用変数
variable "object_viewers" {
  description = "Storage Object Viewer権限を付与するメンバーのリスト"
  type        = list(string)
  default     = []
}

variable "object_admins" {
  description = "Storage Object Admin権限を付与するメンバーのリスト"
  type        = list(string)
  default     = []
}

variable "bucket_admins" {
  description = "Storage Admin権限を付与するメンバーのリスト"
  type        = list(string)
  default     = []
}
