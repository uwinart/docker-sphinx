#!/bin/bash
set -e

/usr/local/bin/indexer --config /data/www/*/sphinx/*.conf --rotate --all
