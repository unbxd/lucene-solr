#!/usr/bin/env bash

# remove v or V from the tag if present
VERSION=${TRAVIS_TAG#(v|V)}

echo "pushing solr package to s3"

aws s3 cp -r package s3://${S3_PATH}/solr/dist/$VERSION

echo "successfully pushed package to s3"
