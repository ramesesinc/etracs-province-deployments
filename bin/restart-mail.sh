#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

cd $BASE_DIR/email/mail-primary && docker-compose down

cd $BASE_DIR/email/mail-primary && docker-compose up -d

cd $BASE_DIR/email/mail-primary && docker-compose logs -f

cd $RUN_DIR
