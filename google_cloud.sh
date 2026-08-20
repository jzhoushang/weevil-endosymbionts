#!/bin/bash

VM_NAME=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/name" -H "Metadata-Flavor: Google")
ZONE=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google" | awk -F'/' '{print $NF}')
BUCKET_NAME="gs://weevil-compbio-bucket"

echo "=== Running Snakemake on $VM_NAME ($ZONE) ==="
snakemake --cores all --use-conda --verbose 2>&1 | tee pipeline.log

echo "=== Workflow Complete: Syncing Output Folders to GCS ==="
gcloud storage rsync -r ./reports/ $BUCKET_NAME/reports/
gcloud storage rsync -r ./data/ $BUCKET_NAME/data/
gcloud storage rsync -r ./pipeline.log $BUCKET_NAME/pipeline.log

echo "=== Upload Complete. Self-destructing instance... ==="
gcloud compute instances delete $VM_NAME --zone=$ZONE --delete-disks=all --quiet
