#!/bin/bash
set -e
ruby lib/start_tcp_server.rb
exec "$@"
