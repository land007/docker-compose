#!/bin/bash
APP_REPOSITORY=$1
DIR=$2
if [ "$(ls -A ${DIR})" ]; then
echo "${DIR} is not Empty"
else
echo "${DIR} is Empty"
echo "cp -R ${DIR}_ ${DIR}"
git clone ${APP_REPOSITORY} ${DIR}
fi
chmod -R 777 ${DIR}
