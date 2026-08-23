sed ':a;N;$!ba;s/\n//g' eol_1.dat | head

sed 's/|^|/\r\n/g' eol_1.dat

tr -d '\r\n' < eol_1.dat > output.txt
tr  '[|^|]' '\r\n' < output.txt > output2.txt
