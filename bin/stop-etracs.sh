#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

cd $BASE_DIR/appserver/etracs && docker-compose down

cd $RUN_DIR
