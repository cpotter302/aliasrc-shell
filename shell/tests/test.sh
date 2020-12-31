

#comp=$(echo "$1" | cut -d'=' -f 1 | awk '{print $2}' )
#[ "$comp" = "$2"  ]

[ "$(echo "$1" | cut -d'=' -f 1 | awk '{print $2}')" != "$2" ]
echo $?
