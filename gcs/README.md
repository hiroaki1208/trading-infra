# GCS Bucket Terraform Module

このディレクトリは、Google Cloud Storage（GCS）バケットを作成するためのTerraformモジュールです。

## 使用方法

1. `terraform.tfvars.json`を編集して、必要なパラメータを設定
2. Terraformコマンドを実行

```bash
# フォーマット
terraform fmt

# 初期化
terraform init

# プラン確認
terraform plan

# 適用
terraform apply
```

## 必須パラメータ

- `project_id`: Google CloudプロジェクトID
- `bucket_name`: GCSバケット名（グローバルでユニークである必要がある）

## オプションパラメータ

- `location`: バケットのロケーション（デフォルト: asia-northeast1）
- `versioning_enabled`: バージョニングの有効/無効（デフォルト: false）
- `force_destroy`: バケット内にオブジェクトがあってもバケットを削除するかどうか（デフォルト: false）

## セキュリティ設定

- パブリックアクセス防止が自動的に有効化されます
- バケットは非公開設定となります

## IAMアクセス権管理

このモジュールでは、以下のIAM権限を管理できます：

### 利用可能な権限レベル

1. **Storage Object Viewer** (`roles/storage.objectViewer`)
   - オブジェクトの読み取り専用アクセス
   - ファイルのダウンロード、一覧表示が可能

2. **Storage Object Admin** (`roles/storage.objectAdmin`)
   - オブジェクトの作成、更新、削除が可能
   - バケット設定の変更は不可

3. **Storage Admin** (`roles/storage.admin`)
   - バケットとオブジェクトの完全な管理権限
   - バケット設定の変更、削除が可能

### メンバーの指定方法

- **サービスアカウント**: `serviceAccount:account@project.iam.gserviceaccount.com`
- **ユーザー**: `user:user@example.com`
- **グループ**: `group:group@example.com`
- **ドメイン**: `domain:example.com`

### 設定例

```json
{
  "object_viewers": [
    "serviceAccount:data-reader@project.iam.gserviceaccount.com",
    "user:analyst@company.com"
  ],
  "object_admins": [
    "serviceAccount:data-processor@project.iam.gserviceaccount.com"
  ],
  "bucket_admins": [
    "serviceAccount:infrastructure@project.iam.gserviceaccount.com"
  ]
}
```

## 主な権限管理方法

1. **google_storage_bucket_iam_binding** - 特定ロールに複数メンバーを一括設定（現在の実装）
2. **google_storage_bucket_iam_member** - 個別メンバーに個別ロールを設定
3. **google_storage_bucket_iam_policy** - バケット全体のIAMポリシーを一括管理
