#!/bin/bash

set -e

# Check and set environment variables
if [ "${POSTGRES_HOST}" = "" ]; then
  echo "You need to set the POSTGRES_HOST environment variable."
  exit 1
fi
if [ "${POSTGRES_USER}" = "" ]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi
if [ "${POSTGRES_PASSWORD}" = "" ]; then
  echo "You need to set the POSTGRES_PASSWORD environment variable."
  exit 1
else
  export PGPASSWORD=$POSTGRES_PASSWORD
fi
if [ "${POSTGRES_DATABASE}" = "" ]; then
  echo "You need to set the POSTGRES_DATABASE environment variable."
  exit 1
fi
if [ "${AWS_ACCESS_KEY_ID}" = "" ]; then
  echo "You need to set the AWS_ACCESS_KEY_ID environment variable."
  exit 1
fi
if [ "${AWS_SECRET_ACCESS_KEY}" = "" ]; then
  echo "You need to set the AWS_SECRET_ACCESS_KEY environment variable."
  exit 1
fi
if [ "${AWS_REGION}" = "" ]; then
  echo "You need to set the AWS_REGION environment variable."
  exit 1
else
  export AWS_DEFAULT_REGION=$AWS_REGION
fi
if [ "${AWS_S3_BUCKET}" = "" ]; then
  echo "You need to set the AWS_S3_BUCKET environment variable."
  exit 1
fi
if [ "${AWS_S3_PATH}" = "" ]; then
  AWS_S3_PREFIX=""
else
  AWS_S3_PREFIX="/${AWS_S3_PATH}"
fi
if [ "${AWS_S3_ENDPOINT}" = "" ]; then
  AWS_ARGS=""
else
  AWS_ARGS="--endpoint-url ${AWS_S3_ENDPOINT}"
fi

# Set Postgres options
POSTGRES_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER $POSTGRES_EXTRA_OPTS"

# Create and zip dump
echo "Creating dump of database: ${POSTGRES_DATABASE} from host: ${POSTGRES_HOST}..."
pg_dump $POSTGRES_OPTS $POSTGRES_DATABASE | gzip > dump.sql.gz
DUMP_SIZE=`wc -c dump.sql.gz | awk '{print $1}'`
if [ $DUMP_SIZE -le 20 ]; then
  echo "Database dump failed, see output of pg_dump for more info."
  exit 2
fi

# Upload dump
echo "Uploading dump to bucket: $AWS_S3_BUCKET..."
cat dump.sql.gz | aws $AWS_ARGS s3 cp - s3://$AWS_S3_BUCKET$AWS_S3_PREFIX/${POSTGRES_DATABASE}_$(date +"%Y-%m-%dT%H:%M:%SZ").sql.gz || exit 2

echo "Database dump backed up successfully!"