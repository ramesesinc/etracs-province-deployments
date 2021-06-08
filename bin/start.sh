#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`


cd $BASE_DIR/email/mail-primary && docker-compose up -d


cd $BASE_DIR/system/notification && docker-compose up -d

cd $BASE_DIR/system/download && docker-compose up -d

cd $BASE_DIR/system/queue && docker-compose up -d

cd $BASE_DIR/system/etracs-web && docker-compose up -d


cd $BASE_DIR/appserver/etracs && docker-compose up -d

cd $BASE_DIR/appserver/epayment && docker-compose up -d


cd $RUN_DIR
