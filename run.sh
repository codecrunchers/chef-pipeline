#/bin/bash
rm /tmp/proj -fR
chef-client -z  -o rxp_pipeline -j attrs.json
