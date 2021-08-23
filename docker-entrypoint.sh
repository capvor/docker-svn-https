#!/bin/bash

set -xe

exec apache2ctl -D FOREGROUND
