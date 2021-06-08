#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`


cd $BASE_DIR/email/mail-primary && docker-compose up -d

cd $RUN_DIR
