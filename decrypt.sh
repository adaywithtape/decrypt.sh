#!/bin/bash
#decrypt.sh v0.1a
#By TAPE
#Last edit 28-07-2018 20:00
VERS=$(sed -n 2p $0 | awk '{print $2}')    #Version information
LED=$(sed -n 4p $0 | awk '{print $3 " " $4}') #Date of last edit to script
#openssl bruteforcer
#openssl enc -aes-256-cbc -d -a -in example.txt.enc -out example.txt -k password
#Written for the beautiful bastards of THE HiVE ;)
#
#						TEH COLORZ :D
########################################################################
STD=$(echo -e "\e[0;0;0m")		#Revert fonts to standard colour/format
REDN=$(echo -e "\e[0;31m")		#Alter fonts to red normal
GRNN=$(echo -e "\e[0;32m")		#Alter fonts to green normal
BLUN=$(echo -e "\e[0;36m")		#Alter fonts to blue normal
BLU=$(echo -e "\e[1;36m")		#Alter fonts to blue bold
ORNN=$(echo -e "\e[0;33m")		#Alter fonts to orange normal
#
#						VARIABLES
########################################################################
BASE64=FALSE
#
#						HEADERS
########################################################################
f_header() {
echo $BLUN"   _   _   _   _   _   _   _   _   _   _  
  / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ 
 ( d | e | c | r | y | p | t | . | s | h )
  \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ 
  openssl decrypter -- $ORNN By TAPE$BLUN  -- $VERS
$STD"
}
#
#						HELP
########################################################################
f_help() {
f_header
echo "Basic Usage:
./$0 -i <input file> -c <cipher> -w <wordlist file>

Options:
-b  --  use base64 decoding 
-c  --  cipher to use
-e  --  examine against expected file type (default: ascii)
-E  --  usage examples
-h  --  this help
-i  --  input file
-o  --  output file (default: decrypted.file)
-w  --  wordlist file (default: password.lst)
"
exit
}
#
#						USAGE EXAMPLES
########################################################################
f_examples() {
f_header
echo "Usage examples; 

./$0 -i <input file>
Script searches for wordlist password.lst and checks input file against all openssl ciphers using found password.lst and outputs 'decrypted.file'

./$0 -i <input file> -c <cipher> 
Script searches for wordlist 'password.lst' and checks file against given cipher, outputs 'decrypted.file'

./$0 -i <input file> -c <cipher> -b -w <wordlist> -o <filename.tmp> 
Checks input file with given cipher, with base64 decoding, against given wordlist and outputting to given filename. 

./$0 -i <input file> -c <cipher> -b -e <filetype> -w <wordlist>
Checks input file with given cipher, with base64 decoding, checks decoded file against given filetype using given wordlist.
"
exit
}
#
#						CIPHERS
########################################################################
f_all_ciphers() {
aes-128-cbc
aes-128-ecb
aes-192-cbc
aes-192-ecb
aes-256-cbc
aes-256-ecb
base64
bf
bf-cbc
bf-cfb
bf-ecb
bf-ofb
camellia-128-cbc
camellia-128-ecb
camellia-192-cbc
camellia-192-ecb
camellia-256-cbc
camellia-256-ecb
cast
cast-cbc
cast5-cbc
cast5-cfb
cast5-ecb
cast5-ofb
des
des-cbc
des-cfb
des-ecb
des-ede
des-ede-cbc
des-ede-cfb
des-ede-ofb
des-ede3
des-ede3-cbc
des-ede3-cfb
des-ede3-ofb
des-ofb
des3
desx
rc2
rc2-40-cbc
rc2-64-cbc
rc2-cbc
rc2-cfb
rc2-ecb
rc2-ofb
rc4
rc4-40
seed
seed-cbc
seed-cfb
seed-ecb
seed-ofb
}
#
#		Check single specified algorythm / cipher
########################################################################
f_single_cipher_check() {
echo $BLUN"[+]$STD Testing file     : $INFILE"
echo $BLUN"[+]$STD Expected filetype: $EXAMINE"
echo $BLUN"[+]$STD Using cipher     : $CIPHER"
while read WORD ; do
	echo -ne $BLUN"[+]$STD Testing password : $REDN$WORD\r$STD"
	CCOUNT=$(echo $WORD | wc -c)
	RESULT=$(openssl enc -$CIPHER -d -in $INFILE -out $OUTFILE -k $WORD 2>&1)
	if [[ "$RESULT" = "" ]] ; then
		f_file_examine
	else
		SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
		echo -ne $BLUN"[+]$STD Testing password : $SPACE\r"
	fi
done < $WORDLIST
echo $REDN"[-]$STD No passwords retrieved for $INFILE"
echo
exit
}
#
#		Check single specified algorythm / cipher with base64 decoding
########################################################################
f_single_cipher_check_base64() {
echo $BLUN"[+]$STD Testing file     : $INFILE"
echo $BLUN"[+]$STD Expected filetype: $EXAMINE"
echo $BLUN"[+]$STD Using cipher     : $CIPHER with base64 decoding"
while read WORD ; do
	echo -ne $BLUN"[+]$STD Testing password : $REDN$WORD\r$STD"
	CCOUNT=$(echo $WORD | wc -c)
	RESULT=$(openssl enc -$CIPHER -d -a -in $INFILE -out $OUTFILE -k $WORD 2>&1)
	if [[ "$RESULT" = "" ]] ; then
		f_file_examine
	else
		SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
		echo -ne $BLUN"[+]$STD Testing password : $SPACE\r"
	fi
done < $WORDLIST
echo $REDN"[-]$STD No passwords retrieved for $INFILE"
echo
exit
}
#
#						Check all algorythms / ciphers with base64
########################################################################
f_all_ciphers_check_base64() {
echo $ORNN"Testing all ciphers.. get comfortable and maybe start a movie..Dances with Wolves is a good and long one..$STD" 
echo $BLUN"[+]$STD Testing file     : $INFILE"
echo $BLUN"[+]$STD Expected filetype: $EXAMINE"
for CIPHER in $(declare -f f_all_ciphers | sed -e 1,2d  -e '$d' -e 's/;//g') ; do
	echo $BLUN"[+]$STD Using cipher     : $CIPHER with base64 decoding"
	while read WORD ; do
		echo -ne $BLUN"[+]$STD Testing password : $REDN$WORD\r$STD"
		CCOUNT=$(echo $WORD | wc -c)
		RESULT=$(openssl enc -$CIPHER -d -a -in $INFILE -out $OUTFILE -k $WORD 2>&1)
		if [[ "$RESULT" = "" ]] ; then
			f_file_examine
		else
			SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
			echo -ne $BLUN"[+]$STD Testing password : $SPACE\r"
		fi
	done < $WORDLIST
	echo $REDN"[-]$STD No passwords retrieved for $INFILE"
	echo
done
exit
}
#
#						Check all algorythms / ciphers
########################################################################
f_all_ciphers_check() {
echo $ORNN"Testing all ciphers.. get comfortable and maybe start a movie..Dances with Wolves is a good and long one..$STD" 
echo $BLUN"[+]$STD Testing file     : $INFILE"
echo $BLUN"[+]$STD Expected typetype: $EXAMINE"
for CIPHER in $(declare -f f_all_ciphers | sed -e 1,2d  -e '$d' -e 's/;//g') ; do
	echo $BLUN"[+]$STD Using cipher     : $CIPHER"
	while read WORD ; do
		echo -ne $BLUN"[+]$STD Testing password : $REDN$WORD\r$STD"
		CCOUNT=$(echo $WORD | wc -c)
		RESULT=$(openssl enc -$CIPHER -d -in $INFILE -out $OUTFILE -k $WORD 2>&1)
		if [[ "$RESULT" = "" ]] ; then
			f_file_examine
		else
			SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
			echo -ne $BLUN"[+]$STD Testing password : $SPACE\r"
		fi
	done < $WORDLIST
	echo $REDN"[-]$STD No passwords retrieved for $INFILE"
	echo
done
exit
}
#
#						Examine decrypted file
########################################################################
f_file_examine() {
EXAMINE=$(echo "$EXAMINE" | tr '[:upper:]' '[:lower:]')
#ASCII
if [ $EXAMINE == ascii ] ; then 
	FILE_INFO=$(file $OUTFILE | grep -i ascii)
	if [[ ! "$FILE_INFO" == "" ]] ; then 
		echo $GRNN"[+]$STD Possible password retrieved: $GRNN$WORD$STD"
		echo $GRNN"[+]$STD Check $ORNN$OUTFILE$STD to view decrypted content"
		exit
	fi
#JPG
elif [ $EXAMINE == jpg ] ; then 
	FILE_INFO=$(file $OUTFILE | egrep -i 'jpg|jpeg')
	if [[ ! $FILE_INFO == "" ]] ; then
		echo $GRNN"[+]$STD Possible password retrieved: $GRNN$WORD$STD"
		echo $GRNN"[+]$STD Check $ORNN$OUTFILE$STD to view decrypted content"
		exit
	fi
fi
}
#
#						OPTION FUNCTIONS
########################################################################
while getopts ":bc:e:Ehi:o:w:" opt; do
  case $opt in
	b) BASE64=TRUE ;;
	c) CIPHER=$OPTARG ;;
	d) DEBUG=TRUE ;; 
	e) EXAMINE=$OPTARG ;;
	E) f_examples ;;
	h) f_help ;;
	i) INFILE=$OPTARG ;;
	o) OUTFILE=$OPTARG ;;
	w) WORDLIST=$OPTARG ;;
  esac
done
#
#						INPUT CHECKS
########################################################################
#
if [ $# -eq 0 ] ; then f_help ; fi
#
if [ -z $OUTFILE ] ; then OUTFILE=decrypted.file ; fi
#
if [ -z $WORDLIST ] ; then WORDLIST=$(locate password.lst | sed -n 1p) ; fi
#
if [ -z $EXAMINE ] ; then EXAMINE=ascii; fi
#
if [ "$BASE64" == "TRUE" ] ; then
	if [ -z $CIPHER ] ; then 
	f_all_ciphers_check_base64
	else f_single_cipher_check_base64
	fi
elif [ "$BASE64" == "FALSE" ] ; then
	if [ -z $CIPHER ] ; then 
	f_all_ciphers_check
	else f_single_cipher_check
	fi
fi
#
#							TO DO
########################################################################
# Currently only provided examine support for ascii / jpg 
# Need to either include more or make the script check for valid file types on 'decryption'
# 
