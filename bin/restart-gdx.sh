#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

cd $BASE_DIR/system/gdx-client && docker-compose down

cd $BASE_DIR/system/gdx-client && docker-compose up -d

cd $BASE_DIR/system/gdx-client && docker-compose logs -f

cd $RUN_DIR
