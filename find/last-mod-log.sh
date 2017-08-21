#!/bin/bash
find . -name '*.log' | xargs ls -hlt > /tmp/logs.txt && vi /tmp/logs.txt
