
gcloud run jobs execute hello-world-daily-job --project=trading-dev-469206 --region=asia-northeast1 --wait

gcloud run jobs describe hello-world-daily-job --project=trading-dev-469206 --region=asia-northeast1 --format="table(status.conditions.type,status.conditions.status,status.conditions.reason,status.conditions.message)"

gcloud artifacts docker images list asia-northeast1-docker.pkg.dev/trading-dev-469206/temp-repo --include-tags

gcloud run jobs describe hello-world-daily-job --project=trading-dev-469206 --region=asia-northeast1 --format="value(template.template.serviceAccount)"

gcloud run jobs describe hello-world-daily-job --project=trading-dev-469206 --region=asia-northeast1 --format=json | jq '.template.template.serviceAccount'

gcloud run jobs describe hello-world-daily-job --project=trading-dev-469206 --region=asia-northeast1 --format="value(template.template.serviceAccount)"


