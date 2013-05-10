#s/bin/sh
user=$1
app=$2

if ! [[ -n $user ]];then
  echo "No username supplied.  Usage: set_permissions.sh username appname"
  exit
fi

curl -X POST -u "$USER:$TOKEN" -d "username=${user}&permission=ALL" https://foundation.iplantcollaborative.org/apps-v1/apps/$app/share |json_xs
