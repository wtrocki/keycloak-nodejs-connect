#!/bin/bash -e

REPO="https://github.com/keycloak/keycloak.git"

echo "Building Keycloak server branch $TRAVIS_BRANCH"

# Clone Keycloak repo
git clone $REPO  > /dev/null 2>&1 && cd keycloak

# The exact version of Keycloak based on Maven
VERSION=`grep -A1 "keycloak-parent" pom.xml | grep "<version>.*</version>$" | awk -F'[><]' '{print $3}'`

# Build the repository based on jboss-public-repository
mvn -s ../scripts/maven-settings.xml clean install --no-snapshot-updates -Pdistribution -DskipTests=true -B -V

# Extract and start the Keycloak server distribution
mkdir ../keycloak-server && tar xzf distribution/server-dist/target/keycloak-$VERSION.tar.gz -C ../keycloak-server --strip-components 1
cd .. 
#&& ./scripts/start-server.sh
