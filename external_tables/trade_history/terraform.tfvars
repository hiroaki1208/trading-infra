dataset_id  = "trading"
table_id    = "raw_trade_history"
source_uris = ["https://docs.google.com/spreadsheets/d/1Y4p4YUkEuf4enm-45VON12HWy3rmfNKcUKi2eTu7IfE"]
sheet_range = "trade_history!A:H"

table_schema = [
  {
    name        = "timestamp_jst"
    type        = "STRING"
    mode        = "NULLABLE"
    description = "レコード入力日時(JST)"
  },
  {
    name        = "trade_date"
    type        = "DATE"
    mode        = "NULLABLE"
    description = "取引日(JST)"
  },
  {
    name        = "ticker"
    type        = "STRING"
    mode        = "NULLABLE"
    description = "ticker名"
  },
  {
    name        = "trade_type"
    type        = "STRING"
    mode        = "NULLABLE"
    description = "取引種別(buy or sell)"
  },
  {
    name        = "account"
    type        = "STRING"
    mode        = "NULLABLE"
    description = "口座名(gp_fund,yuitomaru..)"
  },
  {
    name        = "order_count"
    type        = "INT64"
    mode        = "NULLABLE"
    description = "取引口数"
  },
  {
    name        = "price"
    type        = "FLOAT"
    mode        = "NULLABLE"
    description = "取引価格"
  },
  {
    name        = "memo"
    type        = "STRING"
    mode        = "NULLABLE"
    description = "メモ"
  }
]