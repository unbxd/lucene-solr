#!/bin/bash

# Vars
ROOT_DIRECTORY="$PWD"
MAVEN_SETTINGS="$PWD/.travis.settings.xml"
SOLR_BASE_VERSION=${TRAVIS_TAG//v/}

# Echo For DEBUG
echo "PWD: $PWD"
echo "ROOT_DIRECTORY: $ROOT_DIRECTORY"
echo "MAVEN_SETTINGS: $MAVEN_SETTINGS"
echo "--------------------------------------------------------------------- "
echo ""

# Check If the Maven settings exists
if [ ! -f $MAVEN_SETTINGS ]; then
    echo "Maven Settings [$MAVEN_SETTINGS] doesn't exist. Aborting"
    exit 1
fi

# Check if ant exists
type ant >/dev/null 2>&1 || {
    echo >&2 "Ant doesn't exist. Aborting."; exit 1;
}

# copy the maven settings to destination
cp $MAVEN_SETTINGS $HOME/.m2/settings.xml

echo "--------------------------------------------------------------------- "

if [ -n "$SOLR_BASE_VERSION" ]; then
    echo "Deploying Maven artifacts for tagged build $TRAVIS_TAG"
    ant clean -Dversion=$SOLR_BASE_VERSION -Dm2.repository.id=github \
	-Dm2.repository.url=https://maven.pkg.github.com/unbxd/artifacts \
	generate-maven-artifacts
else
    echo "Deploying Maven artifacts for non-tagged build(snapshots)"
    ant clean -Dm2.repository.id=github \
	-Dm2.repository.url=https://maven.pkg.github.com/unbxd/artifacts \
	generate-maven-artifacts
fi

echo "--------------------------------------------------------------------- "
echo ""
