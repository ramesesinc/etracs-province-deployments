#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

cd $BASE_DIR/system/etracs-web && docker-compose down

cd $RUN_DIR
