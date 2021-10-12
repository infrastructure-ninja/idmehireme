#!/bin/bash
cd /usr/src/app/app
gunicorn --bind=0.0.0.0:${PORT} --worker-class=gevent --worker-connections=1000 --workers=8 app:app
