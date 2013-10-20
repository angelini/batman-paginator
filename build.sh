#!/usr/bin/env bash

cd ~/src/batman
cake build
cp ~/src/batman/lib/batman.js ~/src/batman-sample/
cp ~/src/batman/lib/batman.solo.js ~/src/batman-sample
