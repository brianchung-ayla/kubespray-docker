#!/bin/bash

SECRET=`cat registry |base64`
sed -i "" "/.dockerconfigjson:/s/ .*/  .dockerconfigjson: $SECRET/g" secret-demo.yaml
