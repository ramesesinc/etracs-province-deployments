#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

cd $BASE_DIR/system/download && docker-compose down

cd $BASE_DIR/system/download && docker-compose up -d

cd $BASE_DIR/system/download && docker-compose logs -f

cd $RUN_DIR
