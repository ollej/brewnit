#!/bin/bash
set -e

rm -f /brewnit/tmp/pids/server.pid

exec "$@"
