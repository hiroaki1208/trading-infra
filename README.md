# trading-infra
- トレーディング関連のinfra

# 前準備
- GitHubのレポジトリにクレデンシャルを`TERRAFORM_GCA_PROD/DEV`という名前で登録
- Terraform実行SAに、作成先データセットのbigquery閲覧、編集権限を付与
  - Terraform実行SAは作成先データセットがあるプロジェクトとは別プロジェクトにつくった

- ディレクトリの第一階層はGCPのサービス名のイメージ
  - でも、bigqueryだけは`external_tables`みたいな個別サービス？にする

# `external_tables`を増やしたいとき

- ディレクトリ追加して、ファイルコピー。`terraform.tfvars`のみかえればOKそう
- あと、`terraform.yml`の以下も変更必要
    ```
        strategy:
        matrix:
            directory:
            - external_tables/asset_name_master
            - external_tables/asset_status_history
    ```
- それなら、なんかもうちょっとうまくできそう？
  - `main.tf`, `variables.tf`をテンプレにして、各ディレクトリ内でハイパーリンクで参照するとか？
  - ハイパーリンク参照ってwindowsでできる？

# Cloud run job + cloud scheduler作成時の、各種権限設定
- 前提
  - SAの種類：以下の３種類を作成
    - terraform実行用SA：project: infraに作成。
    - run time用SA：cloud run job実行時に使用するためのSA。prod/devにそれぞれ作成
    - cloud scheduler invoker: cloud schedulerを起動するためのSA。prod/devにそれぞれ作成
- 設定内容
  - terraform実行用SA周り
    - prod/devそれぞれのプロジェクトにて以下を設定
      - cloud run作成
      - cloud scheduler作成
      - act as runtimeSA,cloud sch invSA（それぞれのSAにて、アクセスを許可するプリンシパルにterraform実行SAを追加）
  - cloud sch invSA
    - cloud run起動

# Terraform コマンド概要

## 1. `terraform fmt`（Format）
- **役割**：Terraform設定ファイル（`.tf`や`.tfvars`）を公式スタイルに整形
- **詳細**：
  - インデントやスペースの揃え
  - 属性の並び順統一
  - コメントや改行位置の調整（値は変更しない）
- **目的**：
  - コードスタイル統一
  - レビューの差分を見やすくする
- **例**：
```hcl
# 整形前
variable "region" { type = string  default = "asia-northeast1" }

# 整形後
variable "region" {
  type    = string
  default = "asia-northeast1"
}
```

## 2. `terraform plan`（Plan）

- **役割**：現在のインフラ状態と `.tf` ファイルの差分を比較し、「何を変更するか」の計画を出力

- **詳細**：
  - 現在の state ファイルとクラウドの実際の状態を取得
  - コードとの差分を計算
  - 作成 / 更新 / 削除のリストを表示

- **目的**：
  - 実行前に影響範囲を確認
  - 予期せぬ変更を防止

- **例**：
```txt
# google_storage_bucket.example will be created
+ resource "google_storage_bucket" "example" {
    name     = "my-bucket"
    location = "US"
  }
Plan: 1 to add, 0 to change, 0 to destroy.
```

## 3. `terraform apply`（Apply）

- **役割**：`plan`で表示された内容を実際にインフラに適用

- **詳細**：
  - 作成・更新・削除のAPIを実行
  - 実行後の状態を `terraform.tfstate` に記録

- **実行方法**：
  - `terraform apply` → その場でplan表示＆yes確認
  - `terraform apply tfplan` → 事前に保存したplanファイルを適用（CI/CD向け）

- **注意**：
  - 実際にリソースが変わるため、本番はplan確認後に実行

- **例**：
```txt
# google_storage_bucket.example will be created
+ resource "google_storage_bucket" "example" {
    name     = "my-bucket"
    location = "US"
  }
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```