#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

cd $BASE_DIR/appserver/epayment && docker-compose down

cd $BASE_DIR/appserver/epayment && docker-compose up -d

cd $BASE_DIR/appserver/epayment && docker-compose logs -f

cd $RUN_DIR
