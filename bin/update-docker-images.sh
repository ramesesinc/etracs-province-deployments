#!/bin/sh
echo ""
docker pull nginx:latest
echo ""
docker pull ramesesinc/mail-server:latest
echo ""
docker pull ramesesinc/notification-server:1.0
echo ""
docker pull ramesesinc/node-download-server:0.0.3
echo ""
docker pull ramesesinc/queue-server:2.5.02.01
echo ""
docker pull ramesesinc/gdx-proxy-server:v002
echo ""
docker pull ramesesinc/gdx-client:1.03.01
echo ""
docker pull ramesesinc/etracs-web:2.5.02.01
echo ""
docker pull ramesesinc/local-epayment-server:2.5.01.02.06
echo ""
docker pull ramesesinc/etracs-server-province:2.5.04.01.01
echo ""
