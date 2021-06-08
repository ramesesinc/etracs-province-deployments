#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

cd $BASE_DIR/appserver/epayment && docker-compose up -d

cd $BASE_DIR/appserver/etracs && docker-compose up -d

cd $RUN_DIR
