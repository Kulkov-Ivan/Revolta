#!/bin/bash

if [ -z "$1" ]
then
  echo "Specify image-maker version. Call '$(basename $0) <version>'"
exit 1
fi

NEXUS=sandbox.revolta-engineering.ru

# prompt for Nexus credentials
echo -n "Nexus login: "
read LOGIN

echo -n "Nexus password: "
read -s PASSWORD

BASE_DIR=`dirname $0`

IMG_FILE=prepare-gate-image_$1.tar.gz
DL_URL=https://$NEXUS:1443/repository/deb-private/$IMG_FILE

mkdir image-maker
cd image-maker
curl -L --netrc-file <(cat <<<"machine $NEXUS login $LOGIN password $PASSWORD") $DL_URL -o $IMG_FILE
if [ $? -ne 0 ]; then
  echo "Error download $IMG_FILE from $DL_URL" >&2
  exit 1
fi

tar -xvf $IMG_FILE
if [ $? -ne 0 ]; then
  echo "Error unpack $IMG_FILE" >&2
  exit 1
fi

rm -f $IMG_FILE

echo "Download $IMG_FILE complete. Call 'sudo prepare_gate_image.sh'"
