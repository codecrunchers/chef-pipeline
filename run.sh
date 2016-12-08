#/bin/bash
rm /tmp/proj -fR
docker volume rm $(docker volume ls -q)
chef-client -z  -o rxp_pipeline -j attrs.json
