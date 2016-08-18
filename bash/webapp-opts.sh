#!/bin/bash

show_help() {
    echo ''
    echo 'Run tomcat for webapps'
    echo ''
    echo 'Usage: [-h?dfkc:]'
    echo ''
    echo ' where:'
    echo '  d       - Run tomcat in jpda debug mode'
    echo '  f       - Run the container in the foreground'
    echo '  k       - Remove existing container before starting'
    echo '  c <cmd> - Command to run if container is in foreground (/bin/bash default)'
    echo ''
}

OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
debug=0
foreground=0
stop_first=0
container_cmd=""

while getopts "h?dfkc:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    d)  debug=1
        ;;
    f)  foreground=1
        container_cmd="/bin/bash"
        ;;
    k)  stop_first=1
        ;;
    c)  container_cmd=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

container_loc="-d"

if [ "$foreground" == 1 ]; then
    container_loc="-it --rm"
fi

if [ "$debug" == 1 ]; then
    container_cmd="catalina.sh jpda run"
fi

DEPLOYMENT=`cat dkr-build/deployment`

CONFIG=${DEPLOYMENT}/stage/master/config