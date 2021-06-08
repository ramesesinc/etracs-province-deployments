#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

cd $BASE_DIR/system/gdx-client && docker-compose down

cd $RUN_DIR
