#!/bin/bash

for job in "$@"
do
    echo "OK, I will kill job $job"
    curl -X DELETE -sku "$USER:$TOKEN" https://foundation.iplantc.org/apps-v1/job/$job |json_xs 
done
