#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

cd $BASE_DIR/system/etracs-web && docker-compose down

cd $BASE_DIR/system/etracs-web && docker-compose up -d

cd $BASE_DIR/system/etracs-web && docker-compose logs -f

cd $RUN_DIR
