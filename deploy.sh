#!/usr/bin/bash

pgrep flask

if [[ "$?" == "0" ]]; then
  pkill flask
fi
tar xzvf crypto.tar.gz
cd crypto-site
flask run --host=0.0.0.0 &
