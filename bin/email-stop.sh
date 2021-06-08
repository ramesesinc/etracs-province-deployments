#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`


cd $BASE_DIR/email/mail-primary && docker-compose down

cd $RUN_DIR
