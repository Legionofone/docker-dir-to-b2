
#
# Dockerfile for daily directory backups to AWS S3
#

FROM ubuntu:latest
WORKDIR /dir-to-b2

# Install cron and AWS CLI
RUN apt-get update
RUN apt-get install -y cron 
RUN apt-get install -y python3-pip
RUN apt-get install -y python3-dev 
RUN apt-get install -y build-essential
RUN pip install b2

# Add files
COPY crontab .
COPY backup .
COPY start .

# Register crontab
RUN crontab ./crontab

# Create the upload directory
RUN mkdir -p /upload

CMD [ "/dir-to-b2/start" ]
