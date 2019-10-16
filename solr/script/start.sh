#!/bin/bash

cmd="solr -f"

if [ ! -z "$CLOUD" ]; then
    if [ "$CLOUD" == "yes" ]; then
        [ -z "$ZOOK_SERVERS" ] && {
            echo "Can't start Solr. ZOOK_SERVERS missing. Aborting";
            exit 1;
        }
        cmd="$cmd -c"
        cmd="$cmd -z $ZOOK_SERVERS"
    fi
fi


# Check for other env vars
[ ! -z "$SOLR_HOST" ] && { cmd="$cmd -Dhost=$SOLR_HOST"; }
[ ! -z "$ASSET_ENDPOINT" ] && { cmd="$cmd -DassetEndpoint=$ASSET_ENDPOINT"; }
[ ! -z "$JAVA_OPTS" ] && { cmd="$cmd -a \"$JAVA_OPTS\""; }

echo "$cmd"
exec $cmd
