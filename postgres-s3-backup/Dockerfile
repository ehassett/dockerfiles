FROM debian:11-slim as installer
RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y curl unzip \
  && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install --bin-dir /aws-cli-bin/

FROM debian:11-slim
ARG POSTGRES_VERSION
COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /aws-cli-bin/ /usr/local/bin/
ADD script/* /app/
RUN apt-get update && apt-get upgrade -y && apt-get install -y gnupg lsb-release wget \
  && echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
  && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && apt-get update && apt-get install -y postgresql-client-$POSTGRES_VERSION && apt-get remove -y gnupg lsb-release wget && apt-get autoremove -y && apt-get clean
CMD ["bash","/app/run.sh"]
ENV POSTGRES_HOST= \
  POSTGRES_PORT=5432 \
  POSTGRES_USER= \
  POSTGRES_PASSWORD= \
  POSTGRES_DATABASE= \
  POSTGRES_EXTRA_OPTS= \
  AWS_ACCESS_KEY_ID= \
  AWS_SECRET_ACCESS_KEY= \
  AWS_REGION= \
  AWS_S3_BUCKET= \
  AWS_S3_PATH=db_backups \
  AWS_S3_ENDPOINT= \
  AWS_S3_S3V4=no \
  BACKUP_SCHEDULE=once