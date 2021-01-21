#!/bin/bash

cat <<EOF
-> Removing sources...
EOF

sudo -s -- <<EOF
  rm -rf /usr/lib/alirc
  rm /usr/local/bin/alirc
  rm /usr/bin/alirc
EOF

cat <<EOF
-> Successfully uninstalled alirc
EOF