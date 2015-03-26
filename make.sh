#!/bin/bash
./cleanup.sh
yo h5bp
rm -fr ./img/
cp -fr ./stack/ ./
bower install
npm install
gulp