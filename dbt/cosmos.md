
~~~bash

export PROJECT_ID=""
export REGION="europe-central2"

export REPO_NAME="astronomer-cosmos-dbt"
export IMAGE_NAME="$REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/cosmos-example"
export SERVICE_ACCOUNT_NAME="cloud-run-job-sa"
export DATASET_NAME="astronomer_cosmos_example"
export CLOUD_RUN_JOB_NAME="astronomer-cosmos-example"

gcloud config set project $PROJECT_ID
gcloud config set run/region $REGION

gcloud services enable bigquery.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable run.googleapis.com

echo $SERVICE_ACCOUNT_NAME

# create a service account
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME
gcloud iam service-accounts list

gcloud iam service-accounts keys create key-file.json --iam-account "$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"
cat key-file.json

# grant JobUser role
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
--role="roles/bigquery.jobUser"

# grant DataEditor role
gcloud projects add-iam-policy-binding $PROJECT_ID \
--member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
--role="roles/bigquery.dataEditor"

# Docker image
gcloud artifacts repositories create $REPO_NAME \
--repository-format=docker \
--location=$REGION \
--project $PROJECT_ID

gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://$REGION-docker.pkg.dev
cat docker/Dockerfile

docker rmi -f $IMAGE_NAME
docker build -t $IMAGE_NAME -f docker/Dockerfile .

docker rm dbt-image-test
docker run --name dbt-image-test -it $IMAGE_NAME bash

docker rm dbt-run-test
docker run --name dbt-run-test -it $IMAGE_NAME dbt run


docker push $IMAGE_NAME

# Cloud Run

gcloud run jobs delete $CLOUD_RUN_JOB_NAME

gcloud run jobs create $CLOUD_RUN_JOB_NAME \
--image=$IMAGE_NAME \
--task-timeout=180s \
--max-retries=0 \
--cpu=1 \
--memory=512Mi \
--service-account=$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com

#gcloud run jobs create JOB_NAME --image IMAGE_URL --command COMMAND --args ARG1,ARG-N

gcloud run jobs create $CLOUD_RUN_JOB_NAME \
--image=$IMAGE_NAME \
--task-timeout=180s \
--max-retries=0 \
--cpu=1 \
--memory=512Mi \
--service-account=$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com \
--command="dbt build"

# Secret Manager
gcloud services enable run.googleapis.com secretmanager.googleapis.com

#echo -n "my-secret-value" | gcloud secrets create my-secret --data-file=-

gcloud secrets add-iam-policy-binding snowflake-password \
  --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com \
  --role=roles/secretmanager.secretAccessor


gcloud run jobs create $CLOUD_RUN_JOB_NAME \
--image=$IMAGE_NAME \
--task-timeout=180s \
--max-retries=0 \
--cpu=1 \
--memory=512Mi \
--service-account=$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com \
--args "dbt,build" \
--set-secrets SNOWFLAKE_PASSWORD=snowflake-password:latest

gcloud run jobs create $CLOUD_RUN_JOB_NAME \
--image=$IMAGE_NAME \
--task-timeout=180s \
--max-retries=0 \
--cpu=1 \
--memory=512Mi \
--service-account=$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com \
--set-secrets /tmp/snowflake_private_key_path=snowflake-password:latest


# Cloud Scheduler
gcloud services enable cloudscheduler.googleapis.com run.googleapis.com

export PROJECT_NUMBER=
gcloud scheduler jobs list --location $REGION
gcloud scheduler jobs delete "$CLOUD_RUN_JOB_NAME-scheduler-trigger" --location $REGION

gcloud scheduler jobs create http "$CLOUD_RUN_JOB_NAME-scheduler-trigger" \
  --location $REGION \
  --schedule="0 0 1 * *" \
  --http-method=POST \
  --uri=https://$REGION-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/$PROJECT_ID/jobs/${CLOUD_RUN_JOB_NAME}:run \
  --oauth-service-account-email $PROJECT_NUMBER-compute@developer.gserviceaccount.com

~~~

# DAGs
~~~
gsutil list
export COMPOSER_BUCKET="???"
gsutil list gs://${COMPOSER_BUCKET}/
gsutil list gs://${COMPOSER_BUCKET}/dags/

gsutil cp dags/*.py gs://${COMPOSER_BUCKET}/dags/
gsutil cp -r jaffle_shop gs://${COMPOSER_BUCKET}/dags/


~~~
