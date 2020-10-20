cat input3.txt | awk -F[' '] '{print $2,$1}' | sort -r | awk -F[' '] '{print $2,$1}'
sort input3.txt  -t $' ' -k2 -r
