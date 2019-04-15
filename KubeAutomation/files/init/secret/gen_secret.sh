#!/bin/bash

SECRET=`cat registry.cfg |base64 -w 1000`
sed -i "/.dockerconfigjson:/s/ .*/  .dockerconfigjson: $SECRET/g" secret-demo.yaml
