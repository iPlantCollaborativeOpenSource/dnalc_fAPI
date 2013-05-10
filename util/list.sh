#!/bin/bash
curl  -sku "$USER:$TOKEN" https://foundation.iplantc.org/apps-v1/jobs/list | json_xs | grep '"status"\|"id"\|"software"\|"archivePath"' | grep -v success | perl -pe  's/^\s+//' |sed 's/"sta/\n"sta/'
