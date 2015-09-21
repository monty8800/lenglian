allList=`cat src/coffee/constants/constants.coffee |grep "null"|awk -F":" '{print $1}'|sed 's/\S//' |sort -u`

useList=`grep -orhE "Constants.actionType\..*\S" src/coffee/|awk '{print $1}'|awk -F "." '{print $3}'|sed 's/\S//'|sort -u`

echo "allList\n $allList"
echo "useList\n $useList"

echo "未定义的actiontype列表:" > ERR.md

for u in $useList
do

inAll=`echo $allList|grep $u | wc -l`

if [ $inAll -ne 1 ]
 then
	echo "$u\n" >> ERR.md
	echo "$u not declared"
else
	echo "$u already declared"
fi
done