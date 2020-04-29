#!/bin/bash
SERVER_MEMORY=$3
SERVER_JAR=$2
if [ "$1" == "latest" ]
then
	LATEST_PAPER_VERSION=`curl -s https://papermc.io/api/v1/paper | jq -r '.versions' | jq -r '.[0]'`
	MINECRAF_VERSION=${LATEST_PAPER_VERSION}
	LATEST_PAPER_BUILD=`curl -s https://papermc.io/api/v1/paper/${MINECRAF_VERSION} | jq -r '.builds.latest'`
else
	MINECRAF_VERSION=$1
	LATEST_PAPER_BUILD=`curl -s https://papermc.io/api/v1/paper/${MINECRAF_VERSION} | jq -r '.builds.latest'`
fi

CURRENT_BUILD=$(cat version_history.json | jq -r '.currentVersion')
LATEST_CONCAT="git-Paper-$LATEST_PAPER_BUILD (MC: $LATEST_PAPER_VERSION)"

if [ "${LATEST_CONCAT}" == "${CURRENT_BUILD}" ]
then
	echo -e "Running latest version $LATEST_PAPER_BUILD"
else
	DOWNLOAD_URL="https://papermc.io/api/v1/paper/${MINECRAFT_VERSION}/${BUILD_NUMBER}/download"
	mv ${SERVER_JAR} ${SERVER_JAR}.old
	curl -o $2 ${DOWNLOAD_URL}
fi

java -Xms128M -Xmx${SERVER_MEMORY}M -Dterminal.jline=false -Dterminal.ansi=true -jar ${SERVER_JAR}