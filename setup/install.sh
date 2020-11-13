RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NO_COLOR='\033[0m'
CLEAR_LINE='\r\033[K'

printf "🔎   checking dependencies"

if ! command -v python3 > /dev/null; then
    printf "${CLEAR_LINE}💀${RED}   You must install python3 on your system before setup can continue${NO_COLOR}\n"
    printf "ℹ️   On Ubuntu-Linux🍎 you should 'sudo apt install python'\n"
    exit
fi 