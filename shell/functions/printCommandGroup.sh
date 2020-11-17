if [ -f $ALIAS_RC_ROOT ]; then
    cat $ALIAS_RC_ROOT | grep $1
fi