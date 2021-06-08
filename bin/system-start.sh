#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

cd $BASE_DIR/system/notification && docker-compose up -d

cd $BASE_DIR/system/download && docker-compose up -d

cd $BASE_DIR/system/queue && docker-compose up -d

cd $BASE_DIR/system/etracs-web && docker-compose up -d

cd $RUN_DIR
