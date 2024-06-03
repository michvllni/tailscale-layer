#!/bin/bash -e

source regions.sh

LAYER="tailscale"
MD5SUM=$(md5sum "${LAYER}.zip" | awk '{ print $1 }')
S3KEY="${LAYER}/${MD5SUM}"

for region in "${REGIONS[@]}"; do
  bucket_name="tailscale-layers-mv-${region}"

  echo "Publishing Lambda Layer ${LAYER} in region ${region}..."
  # Must use --cli-input-json so AWS CLI doesn't attempt to fetch license URL
  version=$(aws --region $region lambda publish-layer-version --cli-input-json "{\"LayerName\": \"${LAYER}\",\"Description\": \"Tailscale Lambda Runtime\",\"Content\": {\"S3Bucket\": \"${bucket_name}\",\"S3Key\": \"${S3KEY}\"},\"CompatibleRuntimes\": [\"provided\", \"python3.9\"],\"LicenseInfo\": \"YOLO\"}"  --output text --query Version)
  echo "Published Lambda Layer ${LAYER} in region ${region} version ${version}"

  echo "Setting public permissions on Lambda Layer ${LAYER} version ${version} in region ${region}..."
  aws --region $region lambda add-layer-version-permission --layer-name "${LAYER}" --version-number $version --statement-id=public --action lambda:GetLayerVersion --principal '*' > /dev/null
  echo "Public permissions set on Lambda Layer ${LAYER} version ${version} in region ${region}"
done
