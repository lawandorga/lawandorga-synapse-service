#!/bin/sh
sed -i "s/SYNAPSE_DB_PASSWORD/$SYNAPSE_DB_PASSWORD/" /data/homeserver.yaml
sed -i "s/SYNAPSE_OIDC_SECRET/$SYNAPSE_OIDC_SECRET/" /data/homeserver.yaml
sed -i "s/SYNAPSE_S3_SECRET_KEY/$SYNAPSE_S3_SECRET_KEY/" /data/homeserver.yaml
/start.py $@