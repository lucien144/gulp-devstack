#!/bin/bash
./cleanup.sh
yo h5bp
rm -fr ./img/
cp -fr ./stack/ ./
bower install
npm install
rm make.sh
rm cleanup.sh
rm -fR ./stack/
gulp install
gulp