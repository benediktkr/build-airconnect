#!/bin/sh

if [ "$1" = "sh" ] || [ "$1" = "/bin/sh" ]; then
    exec -l /bin/sh
    exit 0
fi

usage() {
    echo "usage $0 <airupnp|airupnp> [args]"
    exit 1
}

if [ "$AIRCONNECT_AIRUPNP_CONFIG" = "" ]; then
    # set in Dockerfile, so can be changed on runtime
    AIRCONNECT_AIRUPNP_CONFIG="/etc/airupnp.xml"
fi

# set PROG and ARGS vars
if [ -n "$1" ]; then
    # set PROG and ARGS from commandline if given
    PROG=$1
    shift
    if [ -n "$1" ]; then
        ARGS=$2
        shift
    else
        ARGS=$*
    fi
elif [ -n "$AIRCONNECT_PROG" ]; then
    # otherwise use env vars.
    PROG=${AIRCONNECT_PROG}
    ARGS=${AIRCONNECT_ARGS}
else
    # print usage help if neither was set
    usage
fi

if [ "$ARGS" = "" ]; then
    if [ "$PROG" = "airupnp" ]; then
        # set default args for airupnp if not set
        ARGS="-Z -x $AIRCONNECT_AIRUPNP_CONFIG"

    elif [ "$PROG" = "aircast" ]; then
        # no default args for aircast
        ARGS=""
    fi
fi

[ "$PROG" = "airupnp" ] || [ "$PROG" = "aircast" ] || usage

env | grep "AIRCONNECT_"
echo
echo "[ ] entrypoint"
echo "    PROG=${PROG}"
echo "    ARGS=\"${ARGS}\""
echo
echo "[ ] running as:"
echo "    whoami: $(whoami)"
echo "    id: $(id)"
echo

if [ "$PROG" = "airupnp" ]; then
    echo "[ ] config file:"
    echo "    AIRCONNECT_AIRUPNP_CONFIG=$AIRCONNECT_AIRUPNP_CONFIG"
    echo "    contents:"
    cat $AIRCONNECT_AIRUPNP_CONFIG
    echo
fi

set -x
/usr/local/bin/${PROG} $ARGS
