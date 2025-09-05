dataset_id            = "trading"
table_id              = "raw_price_data"
location              = "US"
bucket_name_base      = "takotako-ikaika-trading-a1b2c3"
# 転送対象ファイルパス.dateは転送実行時点のUTC基準であることに注意
gcs_source_path       = "price_data/{date}/fetch_at_*.csv"
transfer_display_name = "Price Data GCS to BigQuery Transfer"
schedule_time         = "22:00"
