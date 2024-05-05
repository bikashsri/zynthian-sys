

cnt=$(ls -1 ./*_output.txt |  sed -e 's/\.\///' -e 's/\(.*\)_\(.*\)/\1/' | sort -n | tail -1)
if [ "$cnt" == "" ]; then
    cnt=1
else
    cnt=$(expr $cnt + 1)
fi
	
out=$cnt"_output.txt"

echo "Renaming output.txt as $out ..."
mv ./output.txt ./$out
