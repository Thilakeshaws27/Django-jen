#!/bin/bash

APP_NAME="myproject"
APP_DIR="/home/ubuntu/django-app"
VENV="$APP_DIR/venv"
GUNICORN_CMD="$VENV/bin/gunicorn"
PIDFILE="$APP_DIR/gunicorn.pid"

case "$1" in
  start)
    cd $APP_DIR
    $GUNICORN_CMD $APP_NAME.wsgi:application \
      --daemon \
      --pid $PIDFILE \
      --bind 0.0.0.0:8000
    ;;
  stop)
    kill `cat $PIDFILE`
    ;;
  restart)
    $0 stop
    sleep 2
    $0 start
    ;;
esac
