#!/bin/bash
#decrypt.sh v0.3
#By TAPE
#Last edit 02-08-2018 22:30
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
bash decrypt.sh -i <input_file> 
bash decrypt.sh -i <input_file> -w <wordlist_file>
bash decrypt.sh -i <input_file> -c <cipher> -b -w <wordlist_file>

Options:
-b  --  use base64 decoding 
-c  --  cipher to use (if omitted all ciphers will be checked)
-d  --  debug // show all variables and options used
-f  --  filetype check (check for expected filetype.. a tad experimental)
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
echo "$BLUN>$STD Extended Help 

-b -- base64 decoding 
Use when encrypted file is also base64 encoded.

-c -- cipher
For example 'aes-256-cbc' 
If omitted then all ciphers listed in the$ORNN f_all_ciphers$STD function will be checked.

-f -- filetype
Not to be used in conjunction with the -u switch.
Checks the decrypted file against an expected filetype. Input must be the first word of filetype as per the 'file' tool.
The script will check this.

-u -- unlikely filetypes
Not to be used in conjunction with the -f switch.
Use this switch to filter out filetypes which have been seen to give false positives in tests. 
Not recommended unless you are confident it wont be one of the filtered filetypes.
All filtered filetypes can be seen in$ORNN f_unlikely$STD function.
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
		f_decrypted_file_check
	else
		SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
		echo -ne $BLUN"[+]$STD Testing password : $SPACE\r"
	fi
done < $WORDLIST
echo $REDN"[!]$STD Wordlist exhausted"
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
		f_decrypted_file_check
	else
		SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
		echo -ne $BLUN"[+]$STD Testing password : $SPACE\r"
	fi
done < $WORDLIST
echo $REDN"[!]$STD Wordlist exhausted"
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
			f_decrypted_file_check
		else
			SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
			echo -ne $BLUN"[+]$STD Testing password : $SPACE\r"
		fi
	done < $WORDLIST
	echo $REDN"[!]$STD Wordlist exhausted"
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
			f_decrypted_file_check
		else
			SPACE=$(head -c $CCOUNT < /dev/zero | tr '\0' '\040')
			echo -ne $BLUN"[+]$STD Testing password : $SPACE\r"
		fi
	done < $WORDLIST
	echo $REDN"[!]$STD Wordlist exhausted"
	echo
done
exit
}
#
#						Noted false positives 
########################################################################
f_unlikely() {
370
64-bit
AIN
Alpha
amd
AmigaOS
ARC
ARJ
Bentley/Intergraph
Bink
BS
byte-swapped
Clarion
COM
Compiled
COFF
crunched
data
disk
DIY
DOS
Dyalog
executable
floppy
frozen
fsav
iAPX
ID
LANalyzer
Linux/i386
little
locale
Logitech
LZH
MAR
MIPSEB
MIPSEL
MySQL
MPEG
MS
openssl
PARIX
packed
PDP-11
PGP
PGP\011Secret
PostScript
Quasijarus
SCO
shared
Sky
SoftQuad
SYMMETRY
SVr2
SVR2
SVr4
structured
SysEx
TeX
VAX-order
very
WE32000
XENIX
YAC
zlib
}
#
#						List of noted false positive filetypes
########################################################################
UNLIKELY_TYPES='370 64-bit AIN Alpha amd AmigaOS ARC ARJ Bentley/Intergraph Bink BS byte-swapped Clarion COM Compiled COFF crunched data disk DIY DOS Dyalog executable floppy frozen fsav iAPX ID LANalyzer Linux/i386 little locale Logitech LZH MAR MIPSEB MIPSEL MySQL MPEG MS openssl PARIX packed PDP-11 PGP PGP\011Secret PostScript Quasijarus SCO shared Sky SoftQuad SYMMETRY SVr2 SVR2 SVr4 structured SysEx TeX VAX-order very WE32000 XENIX YAC zlib'
#
#						Decrypted filetype check
########################################################################
f_decrypted_file_check() {
FILE=$(file $OUTFILE | sed "s/$OUTFILE: //")
FILECHECK=$(echo $FILE | awk '{print $1}')
OUTFILENAME=${OUTFILE}_${WORD}
if [ "$UNLIKELY" == "TRUE" ] ; then
	for i in $UNLIKELY_TYPES; do 
		PASS=MAYBE
		if [[ "$FILECHECK" =~ "$i" ]] ; then 
			PASS=FALSE
			break
		fi
	done
	if [ ! "$PASS" == "FALSE" ]; then
		echo $GRN"[+]$STD Possible filetype: $GRNN$FILE$STD found with password $GRN$WORD$STD"
		echo -e $ORNN"[+]$STD Copying file to  :$ORNN $OUTFILENAME$STD"
		cp $OUTFILE "$OUTFILENAME"
	fi
elif [[ "$UNLIKELY" == "FALSE" ]] && [[ -z $FILETYPE ]] ; then
	if [[ ! "$FILE" = data* ]] && [[ ! "$FILE" = openssl* ]] ; then
	echo $GRN"[+]$STD Possible filetype: $GRNN$FILE$STD found with password $GRN$WORD$STD"
	echo -e $ORNN"[+]$STD Copying file to  :$ORNN $OUTFILENAME$STD"
	cp $OUTFILE "$OUTFILENAME"
	fi
elif [[ "$UNLIKELY" == "FALSE" ]] && [[ ! -z $FILETYPE ]] ; then
	if [ "$FILECHECK" == "$FILETYPE" ] ; then 
		echo $GRN"[+]$STD Possible filetype: $GRNN$FILE$STD found with password $GRN$WORD$STD"
		echo -e $ORNN"[+]$STD Copying file to  :$ORNN $OUTFILENAME$STD"
		cp $OUTFILE "$OUTFILENAME"
		exit
	fi
fi
}
#
#						DEBUG INFO
########################################################################
f_debug() {
FILEINFILE=$(file $INFILE | cut -d : -f 2 | sed 's/^.//')
if [ -z $FILETYPE ] ; then FILETYPE="No filetype specified"; fi
echo $ORNN"-------------------------------------------------------------$STD"
echo $GRNN"[+]$STD Encrypted file to process    : $INFILE"
echo $GRNN"[+]$STD Encrypted file properties    : $FILEINFILE"
echo $GRNN"[+]$STD Cipher(s) being checked      : $CIPHER"
echo $GRNN"[+]$STD Base64 decoding              : $BASE64"
echo $GRNN"[+]$STD Filtering unlikely filetypes : $UNLIKELY" 
echo $GRNN"[+]$STD Filetype to match            : $FILETYPE"
echo $GRNN"[+]$STD Wordlist in use              : $WORDLIST"
echo $GRNN"[+]$STD Output file name             : $OUTFILE"
echo $ORNN"-------------------------------------------------------------$STD"
}

#
#						OPTION FUNCTIONS
########################################################################
while getopts ":bc:df:hHi:o:uw:" opt; do
  case $opt in
	b) BASE64=TRUE ;;
	c) CIPHER=$OPTARG ;;
	d) DEBUG=TRUE ;;
	f) FILETYPE=$OPTARG ;;
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
if [ -z $WORDLIST ] ; then 
	WORDLIST=$(locate password.lst | sed -n 1p)
	if [ "$WORDLIST" == "" ] ; then 
		echo $REDN"[!]$STD No wordlist found. Please specify with$GRNN -w$STD switch"
		exit
	elif [ ! -f $WORDLIST ] ; then
		echo $REDN"[!]$STD Please specify valid wordlist with$GRNN -w$STD switch"
		exit 
	fi
fi
#
if [ -z $INFILE ] ; then 
	echo $REDN"[!]$STD Input file to decrypt must be specified with the$GRNN -i$STD switch"
	exit
fi
#
FILEBASEINFO=$(file $INFILE | cut -d : -f 2 | sed 's/^.//' | grep -i "base64 encoded")
if [[ ! "$FILEBASEINFO" == "" ]] && [[ "$BASE64" == "FALSE" ]] ; then 
	echo $REDN"[!]$STD Encrypted file possibly needs base64 decoding"
	echo $REDN"[!]$STD Consider using the$GRNN -b$STD switch"
	sleep 2
fi
# Checks on unlikely filetype filtering and expected filetype
if [[ "$UNLIKELY" == "TRUE" ]] && [[ ! -z $FILETYPE ]] ; then 
	echo $REDN"[!]$STD Filtering unlikely filetypes cannot be used in conjunction with checking for a specific filetype"
	echo "Please specify either$GRNN -u$STD or$GRNN -f <filetype>$STD"
	exit
elif [[ "$UNLIKELY" == "FALSE" ]] && [[ ! -z $FILETYPE ]] ; then 
	X=$(file -l | sed 's/^.*: //g' | awk '{print $1}' | grep $FILETYPE)
	if [ "$X" == "" ] ; then 
		echo $REDN"[!]$STD Filetype not recognised. Please use first word from 'file' information as string for filetype"
		exit
	fi
fi
#
#
if [ "$BASE64" == "TRUE" ] ; then
	if [ -z $CIPHER ] ; then
		CIPHER="All available ciphers"
		if [ "$DEBUG" == "TRUE" ] ; then f_debug; fi
		f_all_ciphers_check_base64
		else 
		if [ "$DEBUG" == "TRUE" ] ; then f_debug; fi
		f_single_cipher_check_base64
	fi
elif [ "$BASE64" == "FALSE" ] ; then
	if [ -z $CIPHER ] ; then 
		CIPHER="All available ciphers" 
		if [ "$DEBUG" == "TRUE" ] ; then f_debug; fi
		f_all_ciphers_check
	else
	if [ "$DEBUG" == "TRUE" ] ; then f_debug; fi
	f_single_cipher_check
	fi
fi
#
#
#							TO DO
########################################################################
# > Improve on methods to check for specific file type
# > Improve and expand help information
# > Improve on methods on types to filter. Switch?
