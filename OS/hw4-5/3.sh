fnid "$1" -print0 2>/dev/null | xargs -r0 stat -f '%#Lp'| sort | uniq -c | awk '
{print $2 , $1}'
