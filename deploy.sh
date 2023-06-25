#!/usr/bin/bash

pkill flask
tar xzvf crypto.tar.gz
cd crypto-site
flask run --host=0.0.0.0 &
