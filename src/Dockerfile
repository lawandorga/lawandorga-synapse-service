FROM matrixdotorg/synapse:v1.80.0

RUN mkdir /data
RUN pip install synapse-s3-storage-provider
COPY entrypoint.sh /
COPY homeserver.yaml /data/homeserver.yaml
COPY log.yaml /data/log.yaml
RUN chown -R 991:991 /data
EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
