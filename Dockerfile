FROM alpine
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
# Install Imagemagick
RUN apk add --no-cache file
RUN apk --update add imagemagick
RUN apt-get update && \
    apt-get install -y athena-jot
ENTRYPOINT ["/entrypoint.sh"]
