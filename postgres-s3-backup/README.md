# postgres-s3-backup

Backup a postgres database to S3 once or on a schedule.

# Tags

* [`14`, `latest`](Dockerfile): Uses postgresql-client-14
* [`13`](Dockerfile): Uses postgresql-client-13
* [`12`](Dockerfile): Uses postgresql-client-12

# Usage
## Inputs

The following inputs are accepted as environment variables. Defaults are indicated as such.
| ENV                   | Description                                                                   | Required | Default        |
|-----------------------|-------------------------------------------------------------------------------|----------|----------------|
| POSTGRES_HOST         | Database hostname/IP. Can use container name if in the same network.          | yes      |                |
| POSTGRES_USER         | User to access the database.                                                  | yes      |                |
| POSTGRES_PASSWORD     | Password of the database user.                                                | yes      |                |
| POSTGRES_DATABASE     | Name of the database.                                                         | yes      |                |
| AWS_ACCESS_KEY_ID     | AWS access key to use to access the S3 bucket.                                | yes      |                |
| AWS_SECRET_ACCESS_KEY | AWS secret access key to use to access the S3 bucket.                         | yes      |                |
| AWS_REGION            | AWS region in which the S3 bucket lives.                                      | yes      |                |
| AWS_S3_BUCKET         | Name of the S3 bucket.                                                        | yes      |                |
| POSTGRES_PORT         | Database port.                                                                | no       | 5432           |
| POSTGRES_EXTRA_OPTS   | Extra options to pass in to the pg_dump command.                              | no       | none specified |
| AWS_S3_PATH           | Non-root path in which to store dumps.                                        | no       | db_backups     |
| AWS_S3_ENDPOINT       | Non-default endpoint to use to connect to S3.                                 | no       | none specified |
| AWS_S3_S3V4           | Set to "yes" to use the s3v4 signature version.                               | no       | no             |
| BACKUP_SCHEDULE       | Schedule to backup database dumps. Can be once, 15min, hourly, daily, weekly. | no       | once           |

## Docker Compose

The recommended usage of this image is with Docker Compose.
```yaml
version: "3"

services:
  pg_s3_backup:
    container_name: pg_s3_backup
    image: ethanhassett/postgres-s3-backup:latest
    environment:
      - POSTGRES_HOST=host
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DATABASE=database
      - AWS_ACCESS_KEY_ID=AKIA12345678
      - AWS_SECRET_ACCESS_KEY=secretkey
      - AWS_REGION=us-east-2
      - AWS_S3_BUCKET=bucket
      - BACKUP_SCHEDULE=15min
```

## Docker run
Alternative, this can be run as a `docker run` command.
```sh
docker run \
  -e POSTGRES_HOST=host \
  -e POSTGRES_USER=user \
  -e POSTGRES_PASSWORD=password \
  -e POSTGRES_DATABASE=database \
  -e AWS_ACCESS_KEY_ID=AKIA12345678 \
  -e AWS_SECRET_ACCESS_KEY=secretkey \
  -e AWS_REGION=us-east-2 \
  -e AWS_S3_BUCKET=bucket \
  ethanhassett/postgres-s3-backup:latest
```