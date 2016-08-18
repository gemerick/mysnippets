#!/bin/bash

. webapp-opts.sh
. settings

LOG_DIR=$BUILD_DIR/logs/ftp

mkdir -p $SUBMIT_DIR
mkdir -p $LOG_DIR
#rm -rf $LOG_DIR/*.log

if [ "$stop_first" == 1 ]; then
    docker rm -fv ftp
fi

docker run --name ftp -p 8080:8080 -p 7000:8000 \
    --net=$NETWORK_NAME $LINKS \
    -e "CATALINA_OPTS=-Dconfig.dir=/usr/local/tomcat/config -Dcom.amazonaws.regions.RegionUtils.fileOverride=/act/local-env-aws-regions-override.xml -Dcom.amazonaws.sdk.ec2MetadataServiceEndpointOverride=$EC2_METADATA_URL" \
    -v $LOG_DIR:/usr/local/tomcat/logs:rw \
    -v `pwd`/tomcat/:/act:ro \
    -v `pwd`/tomcat/tomcat-users.xml:/usr/local/tomcat/conf/tomcat-users.xml \
    -v $CONFIG:/usr/local/tomcat/config \
    $container_loc tomcat:7.0.69-jre8 $container_cmd
