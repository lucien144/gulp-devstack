#!/bin/bash
find . -maxdepth 1 ! -name 'stack' ! -name 'make.sh' ! -name 'cleanup.sh' ! -name '.' ! -name '..' | xargs rm -rf