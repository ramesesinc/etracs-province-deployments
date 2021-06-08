#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`


cd $BASE_DIR/system/etracs-web && docker-compose down

cd $BASE_DIR/system/notification && docker-compose down

cd $BASE_DIR/system/download && docker-compose down

cd $BASE_DIR/system/queue && docker-compose down

cd $RUN_DIR
