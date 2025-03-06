FROM python:3.11

ENV GCP_PROJECT_ID=""
ENV GCP_REGION="europe-central2"

ENV BIGQUERY_DATASET=jaffle_shop
ENV BIGQUERY_PRIORITY=interactive
ENV BIGQUERY_THREADS=1
ENV BIGQUERY_TIMEOUT=300
ENV BIGQUERY_JOB_RETRIES=1
ENV GCP_AUTH_METHOD=oauth

RUN #pip install dbt-core==1.8.2 dbt-bigquery==1.8.1
RUN pip install dbt-core==1.8.2 dbt-snowflake==1.8.1

RUN mkdir /root/.dbt

COPY dags dags
COPY jaffle_shop /dags/dbt/jaffle_shop

COPY docker/example_snowflake_profile.yml /root/.dbt/profiles.yml

#COPY docker/example_bigquery_profile.yml /root/.dbt/profiles.yml
#COPY docker/bigquery_profile_dbt_project.yml dags/dbt/jaffle_shop/dbt_project.yml

WORKDIR /dags/dbt/jaffle_shop
