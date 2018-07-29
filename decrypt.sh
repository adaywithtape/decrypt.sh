#!/bin/bash
#decrypt.sh v0.1
#By TAPE
#Last edit 29-07-2018 23:00
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
GRN=$(echo -e "\e[1;32m")		#Alter fonts to green bold
BLUN=$(echo -e "\e[0;36m")		#Alter fonts to blue normal
BLU=$(echo -e "\e[1;36m")		#Alter fonts to blue bold
ORNN=$(echo -e "\e[0;33m")		#Alter fonts to orange normal
#
#						VARIABLES
########################################################################
BASE64=FALSE
DEBUG=FALSE
UNLIKELY=FALSE
#
#						HEADERS
########################################################################
f_header() {
echo $STD"   _   _   _   _   _   _   _   _   _   _  
  / \ / \ / \ / \ / \ / \ / \ / \ / \ / \ 
 ($BLUN d$STD |$BLUN e$STD |$BLUN c$STD |$BLUN r$STD |$BLUN y$STD |$BLUN p$STD |$BLUN t$STD |$BLUN .$STD |$BLUN s$STD |$BLUN h$STD )
  \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ $BLUN
  openssl decrypter -- $ORNN By TAPE$BLUN  -- $VERS$STD"
}
#
#						HELP
########################################################################
f_help() {
f_header
echo $BLUN">$STD Help information

Basic Usage:
bash decrypt.sh -i <input file> 
bash decrypt.sh -i <input file> -w <wordlist file>
bash decrypt.sh -i <input file> -c <cipher> -b -w <wordlist file>

Options:
-b  --  use base64 decoding 
-c  --  cipher to use
-f  --  filetype check
-h  --  this help
-H  --  extended help
-i  --  input file
-o  --  output file (default: decrypted.file)
-u  --  filter out unlikely filetypes (see extended help)
-w  --  wordlist file (default: password.lst)
"
exit
}
#
#						USAGE EXAMPLES
########################################################################
f_extended_help() {
f_header
echo "
$BLUN>$STD Extended Help 


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
echo $BLUN"[+]$STD Using cipher     : $CIPHER"
while read WORD ; do
	echo -ne $BLUN"[+]$STD Testing password : $REDN$WORD\r$STD"
	CCOUNT=$(echo $WORD | wc -c)
	RESULT=$(openssl enc -"$CIPHER" -d -in "$INFILE" -out "$OUTFILE" -k "$WORD" 2>&1)
	if [[ "$RESULT" = "" ]] ; then
		f_filetype_check
	else
		SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
		echo -ne $BLUN"[+]$STD Testing password : $SPACE\r"
	fi
done < $WORDLIST
echo $REDN"[-]$STD Wordlist exhausted"
echo
exit
}
#
#		Check single specified algorythm / cipher with base64 decoding
########################################################################
f_single_cipher_check_base64() {
echo $BLUN"[+]$STD Testing file     : $INFILE"
echo $BLUN"[+]$STD Using cipher     : $CIPHER with base64 decoding"
while read WORD ; do
	echo -ne $BLUN"[+]$STD Testing password : $REDN$WORD\r$STD"
	CCOUNT=$(echo $WORD | wc -c)
	RESULT=$(openssl enc -$CIPHER -d -a -in $INFILE -out $OUTFILE -k $WORD 2>&1)
	if [[ "$RESULT" = "" ]] ; then
		f_filetype_check
	else
		SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
		echo -ne $BLUN"[+]$STD Testing password : $SPACE\r"
	fi
done < $WORDLIST
echo $REDN"[-]$STD Wordlist exhausted"
echo
exit
}
#
#						Check all algorythms / ciphers with base64
########################################################################
f_all_ciphers_check_base64() {
echo $ORNN"Testing all ciphers..get comfortable and maybe start a movie..Dances with Wolves is a good and long one..$STD" 
echo $BLUN"[+]$STD Testing file     : $INFILE"
for CIPHER in $(declare -f f_all_ciphers | sed -e 1,2d  -e '$d' -e 's/;//g') ; do
	echo $BLUN"[+]$STD Using cipher     : $CIPHER with base64 decoding"
	while read WORD ; do
		echo -ne $BLUN"[+]$STD Testing password : $REDN$WORD\r$STD"
		CCOUNT=$(echo $WORD | wc -c)
		RESULT=$(openssl enc -"$CIPHER" -d -a -in "$INFILE" -out "$OUTFILE" -k "$WORD" 2>&1)
		if [[ "$RESULT" = "" ]] ; then
			f_filetype_check
		else
			SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
			echo -ne $BLUN"[+]$STD Testing password : $SPACE\r"
		fi
	done < $WORDLIST
	echo $REDN"[-]$STD Wordlist exhausted"
	echo
done
exit
}
#
#						Check all algorythms / ciphers
########################################################################
f_all_ciphers_check() {
echo $ORNN"Testing all ciphers..get comfortable and maybe start a movie..Dances with Wolves is a good and long one..$STD" 
echo $BLUN"[+]$STD Testing file     : $INFILE"
for CIPHER in $(declare -f f_all_ciphers | sed -e 1,2d  -e '$d' -e 's/;//g') ; do
	echo $BLUN"[+]$STD Using cipher     : $CIPHER"
	while read WORD ; do
		echo -ne $BLUN"[+]$STD Testing password : $REDN$WORD\r$STD"
		CCOUNT=$(echo $WORD | wc -c)
		RESULT=$(openssl enc -$CIPHER -d -in $INFILE -out $OUTFILE -k $WORD 2>&1)
		if [[ "$RESULT" = "" ]] ; then
			f_filetype_check
		else
			SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
			echo -ne $BLUN"[+]$STD Testing password : $SPACE\r"
		fi
	done < $WORDLIST
	echo $REDN"[-]$STD Wordlist exhausted"
	echo
done
exit
}
#
#						List of noted false positive filetypes
########################################################################
f_unlikely() {
COM*
COFF*
data
DIY*
DOS*
MPEG*
openssl*
PGP*
SysEx*
zlib*
}
#
#						Decrypted filetype check
########################################################################
f_filetype_check() {
FILETYPE=$(file $OUTFILE)
FILETYPE=$(echo $FILETYPE | sed "s/$OUTFILE: //")
if [ "$UNLIKELY" == "TRUE" ] ; then
	if [[ ! "$FILETYPE" = data ]] && [[ ! "$FILETYPE" = openssl* ]] &&  [[ ! "$FILETYPE" = DIY* ]] && [[ ! "$FILETYPE" = DOS* ]] && [[ ! "$FILETYPE" = PGP* ]] && [[ ! "$FILETYPE" = SysEx* ]]  ; then
		if [[ ! "$FILETYPE" = $TYPE ]] ; then
			echo $GRN"[+]$STD Possible filetype: $GRNN$FILETYPE$STD found with password $GRN$WORD$STD"
			echo $ORNN"[+]$STD Copying file to  :$ORNN decrypted.file_$WORD$STD"
			cp $OUTFILE decrypted.file_$WORD
		fi
	fi
elif [ "$UNLIKELY" == "FALSE" ] ; then
	if [[ ! "$FILETYPE" = data ]] && [[ ! "$FILETYPE" = openssl* ]] ; then
	echo $GRN"[+]$STD Possible filetype: $GRNN$FILETYPE$STD found with password $GRN$WORD$STD"
	echo $ORNN"[+]$STD Copying file to  :$ORNN decrypted.file_$WORD$STD"
	cp $OUTFILE decrypted.file_$WORD
	fi
fi
}
#
#						OPTION FUNCTIONS
########################################################################
while getopts ":bc:f:hHi:o:uw:" opt; do
  case $opt in
	b) BASE64=TRUE ;;
	c) CIPHER=$OPTARG ;;
	d) DEBUG=TRUE ;;
	H) f_extended_help ;;
	h) f_help ;;
	i) INFILE=$OPTARG ;;
	o) OUTFILE=$OPTARG ;;
	u) UNLIKELY=TRUE ;;
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



