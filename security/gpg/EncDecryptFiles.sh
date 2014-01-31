# 
# Version : alpha 0.01
# 
# 
# 
#gnupg
#
#GnuPG stands for GNU Privacy Guard and is GNU's tool for secure communication and data storage. It can be used to encrypt data and to create digital signatures. It includes an advanced key management facility.
#ncrypting a file in linux
#
#o encrypt a single file, use command gpg as follows:
#gpg -c filename
#
##o encrypt myfinancial.info.txt file, type the command:
# gpg -c myfinancial.info.txt
#Simple output:
#
#Enter passphrase:<YOUR-PASSWORD>
#Repeat passphrase:<YOUR-PASSWORD>
#
#This will create a myfinancial.info.txt.gpg file. Where,
#
#    -c : Encrypt with symmetric cipher using a passphrase. The default symmetric cipher used is CAST5, but may be chosen with the --cipher-algo option. This option may be combined with --sign (for a signed and symmetrically encrypted message), --encrypt (for a message that may be decrypted via a secret key or a passphrase), or --sign and --encrypt together (for a signed message that may be decrypted via a secret key or a passphrase).
#
#Please note that if you ever forgot your password (passphrase), you cannot recover the data as it use very strong encryption.
#Decrypt a file
#
#To decrypt file use the gpg command as follow:
#$ gpg myfinancial.info.txt.gpg
#Sample outputs:
#
#gpg myfinancial.info.txt.gpg
#gpg: CAST5 encrypted data
#Enter passphrase:<YOUR-PASSWORD>
#
#Decrypt file and write output to file vivek.info.txt you can run command:
#$ gpg myfinancial.info.gpg –o vivek.info.txt
#Also note that if file extension is .asc, it is a ASCII encrypted file and if file extension is .gpg, it is a binary encrypted file.
