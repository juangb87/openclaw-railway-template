#!/bin/bash
set -e

chown -R openclaw:openclaw /data
chmod 700 /data

if [ -d /home/linuxbrew/.linuxbrew ]; then
  mkdir -p /home/linuxbrew
  if [ ! -d /data/.linuxbrew ]; then
    cp -a /home/linuxbrew/.linuxbrew /data/.linuxbrew
  fi
  rm -rf /home/linuxbrew/.linuxbrew
  ln -sfn /data/.linuxbrew /home/linuxbrew/.linuxbrew
  chown -h openclaw:openclaw /home/linuxbrew/.linuxbrew || true
  chown -R openclaw:openclaw /data/.linuxbrew || true
fi

exec gosu openclaw node src/server.js
