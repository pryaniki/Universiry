ls | tee foo bar
echo "4" | tee 1 2
cat foo bar > buz
cat foo bar | cut -c 1-6 > buz