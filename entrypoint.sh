#!/bin/bash
set -e
ruby lib/client_thread.rb
exec "$@"
