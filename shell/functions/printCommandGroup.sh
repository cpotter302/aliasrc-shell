RED=$(tput setab 0; tput setaf 1)
NONE=$(tput sgr0)

if [ -f $ALIAS_RC_ROOT ] && [[ ! -z $(grep $1<$ALIAS_RC_ROOT) ]]; then 
    (grep $1)<$ALIAS_RC_ROOT
else
    echo -e "Group: ${RED}$1${NONE} not found"
fi