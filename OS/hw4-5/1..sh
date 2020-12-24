find "$1" -group "$2" -perm -g+w -mount -print 2>/dev/null | while read file; do
 ls -l -- "$file" ; done | awk ' { print $3 " " $10 }'
