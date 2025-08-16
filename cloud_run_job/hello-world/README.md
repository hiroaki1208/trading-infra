# Hello World Cloud Run Job

このディレクトリには、Artifact Registryの`hello-world`イメージを使用して毎日定期実行するCloud Run Jobの設定が含まれています。

## 概要

- **Cloud Run Job**: `hello-world-daily-job`
- **スケジュール**: 毎日9時（JST）に実行
- **イメージ**: `asia-northeast1-docker.pkg.dev/trading-prod-468212/trading-infra/hello-world:latest`

## 構成ファイル

- `main.tf`: Terraformのメイン設定ファイル
- `variables.tf`: 変数定義ファイル
- `terraform.tfvars`: 変数値設定ファイル

## 設定内容

### Cloud Run Job
- **リソース制限**: CPU 1コア、メモリ 512Mi
- **実行設定**: 
  - 最大リトライ回数: 3回
  - 並列実行数: 1
  - タスク数: 1
  - タイムアウト: 3600秒（1時間）

### Cloud Scheduler
- **スケジュール**: `0 9 * * *` (毎日9時JST)
- **タイムゾーン**: Asia/Tokyo
- **リトライ設定**: 1回

## 必要な権限

以下のAPIが有効化されます：
- Cloud Run API (`run.googleapis.com`)
- Cloud Scheduler API (`cloudscheduler.googleapis.com`)

## カスタマイズ

### スケジュールの変更
`terraform.tfvars`の`schedule_cron`値を変更してください：
```hcl
schedule_cron = "0 9 * * *"  # 毎日9時
# schedule_cron = "0 */6 * * *"  # 6時間毎
# schedule_cron = "0 9 * * 1"  # 毎週月曜日9時
```

### コンテナイメージの変更
`terraform.tfvars`の`container_image`値を変更してください：
```hcl
container_image = "asia-northeast1-docker.pkg.dev/trading-prod-468212/trading-infra/hello-world:v1.0.0"
```

### 環境変数の追加
`terraform.tfvars`の`environment_variables`に設定してください：
```hcl
environment_variables = {
  "ENV_NAME" = "production"
  "LOG_LEVEL" = "info"
}
```

## デプロイ

このコンポーネントは、GitHubのCI/CDパイプラインによって自動的にデプロイされます。プルリクエストでplanが確認でき、mainブランチへのマージでapplyが実行されます。

## 注意事項

1. `service_account_email`は実際に存在するサービスアカウントのメールアドレスに変更してください
2. コンテナイメージは事前にArtifact Registryにプッシュされている必要があります
3. 初回デプロイ時は、既存のリソースがある場合はインポート処理が実行されます
