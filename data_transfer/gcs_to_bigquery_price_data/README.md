# Data Transfer - GCS to BigQuery

このディレクトリは、GCS（Google Cloud Storage）からBigQueryへの定期的なデータ転送を設定するためのTerraformモジュールです。

## 概要

- **転送元**: GCSバケット内のCSVファイル（`price_data/fetch_at_*.csv`）
- **転送先**: BigQuery `trading.price_data` テーブル
- **スケジュール**: 毎日15時（JST）に実行
- **転送方式**: BigQuery Data Transfer Service（APPEND モード）

## 構成ファイル

- `main.tf`: Terraformのメイン設定ファイル
- `variables.tf`: 変数定義ファイル  
- `terraform.tfvars.json`: 変数値設定ファイル

## 設定内容

### BigQueryテーブル
- **データセット**: `trading`
- **テーブル名**: `price_data`
- **スキーマ**:
  - `date` (DATE): 取引日
  - `ticker` (STRING): ティッカーシンボル
  - `ohlc_type` (STRING): OHLC種別（open, high, low, close）
  - `price` (FLOAT): 価格
  - `fetch_time` (TIMESTAMP): データ取得時刻

### GCSソースファイル
- **バケット**: 
  - dev: `takotako-ikaika-trading-a1b2c3-dev`
  - prod: `takotako-ikaika-trading-a1b2c3-prod`
- **ファイルパス**: `price_data/fetch_at_*.csv`
- **ファイル形式**: CSV（ヘッダー行あり、UTF-8エンコーディング）

### Data Transfer Service
- **スケジュール**: 毎日15時（JST）
- **書き込みモード**: APPEND（既存データに追加）
- **専用サービスアカウント**: 必要な権限を持つSAを自動作成

## 必要な権限

以下のAPIが有効化されます：
- BigQuery API (`bigquery.googleapis.com`)
- BigQuery Data Transfer API (`bigquerydatatransfer.googleapis.com`)
- Cloud Storage API (`storage.googleapis.com`)

作成されるサービスアカウントには以下の権限が付与されます：
- `roles/bigquery.dataEditor`: BigQueryへのデータ書き込み
- `roles/storage.objectViewer`: GCSからのファイル読み取り

## CSVファイル形式

期待されるCSVファイル形式：

```csv
date,ticker,ohlc_type,price,fetch_time
2025-08-21,AAPL,open,150.25,2025-08-22T06:00:00Z
2025-08-21,AAPL,high,152.10,2025-08-22T06:00:00Z
2025-08-21,AAPL,low,149.80,2025-08-22T06:00:00Z
2025-08-21,AAPL,close,151.50,2025-08-22T06:00:00Z
```

## 使用方法

### ファイルのアップロード
1. CSVファイルを指定の命名規則で作成：`fetch_at_yyyymmdd_hhss.csv`
2. 適切なGCSバケットの`price_data/`ディレクトリにアップロード

### 転送の監視
1. BigQuery コンソールでData Transfer Serviceの実行状況を確認
2. `trading.price_data`テーブルでデータの追加を確認

## カスタマイズ

### スケジュールの変更
`terraform.tfvars.json`の`schedule_time`値を変更してください：
```json
{
  "schedule_time": "09:00"
}
```

### ファイルパスパターンの変更
`terraform.tfvars.json`の`gcs_source_path`値を変更してください：
```json
{
  "gcs_source_path": "price_data/fetch_at_*.csv"
}
```

## デプロイ

このコンポーネントは、GitHubのCI/CDパイプラインによって自動的にデプロイされます：
- プルリクエストでdev環境にplanとapplyが実行されます
- mainブランチへのマージでprod環境にapplyが実行されます

## 注意事項

1. GCSバケットは事前に作成されている必要があります（`gcs`モジュールで作成済み）
2. `trading`データセットは事前に存在している必要があります
3. CSVファイルのスキーマはテーブル定義と一致している必要があります
4. 転送失敗時は BigQuery コンソールでエラー詳細を確認してください

## トラブルシューティング

### よくある問題
1. **権限エラー**: サービスアカウントにGCSバケットへのアクセス権限があることを確認
2. **スキーマエラー**: CSVファイルの列数・型がテーブル定義と一致していることを確認
3. **ファイルが見つからない**: GCSのファイルパスとパターンが正しいことを確認
