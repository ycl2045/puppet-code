#!/usr/bin/env bash
ip -4 route get 10.0.0.0 2>/dev/null | awk '/src/ { sub("metric.*",""); print "gfcertname="$NF  }'
