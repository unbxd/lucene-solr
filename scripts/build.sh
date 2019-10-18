#!/bin/bash

echo "--------------------------------------------------------------------- "
echo "BUILDING SOLR "
echo "--------------------------------------------------------------------- "
echo ""

# Vars
PWD="$(pwd)"
LUCENE_DIRECTORY="$PWD"
SOLR_DIR="$PWD/solr"
SOLR_BASE_VERSION=${TRAVIS_TAG//v/}

# Echo For DEBUG
echo "PWD: $PWD"
echo "LUCENE_DIRECTORY: $LUCENE_DIRECTORY"
echo "SOLR_DIR: $SOLR_DIR"
echo "SOLR_BASE_VERSION: $SOLR_BASE_VERSION"
echo "--------------------------------------------------------------------- "
echo ""

echo "--------------------------------------------------------------------- "
echo "RUNNING ANT TO BUILD LUCENE"
echo "--------------------------------------------------------------------- "
echo ""

if [ -n "$SOLR_BASE_VERSION" ]; then
  ant \
    clean \
    compile \
    jar -Dversion.suffix=unbxd -Dversion.base=$SOLR_BASE_VERSION
else
  ant \
    clean \
    compile \
    jar -Dversion.suffix=unbxd
fi

cd $SOLR_DIR

echo "--------------------------------------------------------------------- "
echo "RUNNING ANT TO BUILD SOLR"
echo "--------------------------------------------------------------------- "
echo ""

if [ -n "$SOLR_BASE_VERSION" ]; then
  ant package -Dversion.suffix=unbxd -Dversion.base=$SOLR_BASE_VERSION
  else ant package -Dversion.suffix=unbxd
fi
