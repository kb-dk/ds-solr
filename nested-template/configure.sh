#!/bin/bash


ZKCLI="../solr-8.11.2/server/scripts/cloud-scripts/zkcli.sh"

$ZKCLI -zkhost localhost:11007 --confname ds-schema --cmd upconfig --confdir nested-template/conf

