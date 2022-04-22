
path="/project_path/mac"
today=`date +%m-%d-%Y-%H:%M`
rm "$path/mac-data/master.csv"


sql_user=$(cat $path/.creds | grep sql | cut -f 1 -d , | cut -f 2 -d =)
sql_pwd=$(cat $path/.creds | grep sql | cut -f 2 -d ,)
sql_db=$(cat $path/.creds | grep sql | cut -f 3 -d ,)


while read line ;do
	
	switch=`echo $line | cut -f 1 -d,`
	method=`echo $line | cut -f 3 -d,`
	site=`echo $switch | cut -c3-5`

	echo "Formatting Switch $switch ($method) data and storing in master.csv.." 
	
	while read data ;do
		if [ $method != "2" ] 
		then


			key=`echo $data | cut -f 1 -d' ' `
			mac=`echo $data | cut -f 2 -d: | sed 's/ /:/g' | tr '[:upper:]' '[:lower:]' | sed "s/,:/,/g" | cut -c2-`

			if=`grep $key "$path/mac-data/$switch.if" | cut -f 2 -d : | tr -d ' '`

			#echo "$site,$switch,$mac,$if"
			echo ",$site,$switch,$mac,$if" >> $path/mac-data/master.csv
		else
			   mac=`echo $data | cut -f 1 -d =`
                           port=`echo $data | cut -f 2 -d: | tr -d ' '`
                           mac=`$path/dec-to-hex.py $mac`

                           #echo "$site,$switch,$mac,$port"
                           echo ",$site,$switch,$mac,$port" >> $path/mac-data/master.csv
		fi

	done<$path/mac-data/$switch.mac


done<$path/switches.dat 


cp $path/mac-data/master.csv $path/mac-data/archive/master-$today.csv


sql_load_file="$path/mac-data/master.csv"

sql="TRUNCATE mac;LOAD DATA LOCAL INFILE  '$sql_load_file' INTO TABLE mac FIELDS TERMINATED BY ',';"

/usr/bin/mysql -u "$sql_user" -p"$sql_pwd" "$sql_db" -e "$sql"


