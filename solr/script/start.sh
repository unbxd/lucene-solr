#!/bin/bash

cmd="solr -f"

if [ ! -z "$CLOUD" ]; then 
    if [ "$CLOUD" == "yes" ]; then
        [ -z "$ZK_HOST" ] && {
            echo "Can't start Solr. ZK_HOST missing. Aborting";
            exit 1;
        }
        cmd="$cmd -c"
        cmd="$cmd -z $ZK_HOST"
    fi
fi


# Check for other env vars
[ ! -z "$ASSET_ENDPOINT" ] && { cmd="$cmd -DassetEndpoint=$ASSET_ENDPOINT"; }
[ ! -z "$JAVA_OPTS" ] && { cmd="$cmd -a \"$JAVA_OPTS\""; }

echo "$cmd"
exec $cmd
