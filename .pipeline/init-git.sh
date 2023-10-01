#!/bin/bash

if [ -d "./${AIRCONNECT_REPO_NAME}/.git" ]; then
    echo "clone of the ${AIRCONNECT_REPO_NAME} repo exists, updating branch '${AIRCONNECT_REPO_BRANCH}'."
    (
        cd ${AIRCONNECT_REPO_NAME}/
        git checkout .
        git clean -fd
        git remote rm origin
        git remote add origin ${AIRCONNECT_REPO_ORIGIN}
        git pull origin ${AIRCONNECT_REPO_BRANCH}
        git checkout ${AIRCONNECT_REPO_BRANCH}
    )
else
    echo "clone of the ${AIRCONNECT_REPO_NAME} does not exist, cloning ${AIRCONNECT_REPO_ORIGIN}"
    git clone ${AIRCONNECT_REPO_ORIGIN}
fi
