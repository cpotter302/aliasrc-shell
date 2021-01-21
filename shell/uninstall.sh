#!/bin/bash

cat <<EOF
-> Removing sources...
EOF

sudo -s -- <<EOF
  rm -rf /usr/lib/ali
  rm /usr/local/bin/ali
  rm /usr/bin/ali
  rm -rf /usr/share/man/man8/ali.8.gz
EOF

cat <<EOF
-> Successfully uninstalled ali
EOF