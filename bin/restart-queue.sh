#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

cd $BASE_DIR/system/queue && docker-compose down

cd $BASE_DIR/system/queue && docker-compose up -d

cd $BASE_DIR/system/queue && docker-compose logs -f

cd $RUN_DIR
