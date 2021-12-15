#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

cd $BASE_DIR/system/gdx-client && docker-compose down

cd $BASE_DIR/system/gdx-client && docker-compose -f docker-compose.yml -f docker-compose-ext.yml up -d

cd $BASE_DIR/system/gdx-client && docker-compose logs -f

cd $RUN_DIR
