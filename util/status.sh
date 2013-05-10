#!/bin/bash
curl -sku "$USER:$TOKEN" https://foundation.iplantc.org/apps-v1/job/$1 |json_xs |more
