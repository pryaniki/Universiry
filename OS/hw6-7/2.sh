find "$1" -print |while read var1; do objdump -p "$var1" 2>/dev/null ; done echo
 "$var1"
