# Quelle http://pastebin.com/XAFhc0VU

# Username dd solte Anders sein !!
# mailboxes_update sthet für die Tabele in der Datenbank !!

 
MYSQL_DB=""
USERNAME="dd"

SELECT CONCAT('{SSHA}', SHA1(CONCAT('secret', @salt)), @salt);
 
DROP FUNCTION MYPASS $$
CREATE FUNCTION MYPASS(UU VARCHAR(256), PP VARCHAR(256)) RETURNS VARCHAR(256)
DETERMINISTIC
BEGIN
UPDATE `mailboxes_update` SET `passwordMD5`=MD5(PP) where `username`=UU;
UPDATE `mailboxes_update` SET `passwordSHA1`=SHA1(PP) where `username`=UU;
UPDATE `mailboxes_update` SET `passwordNEW`=PASSWORD(PP) where `username`=UU;
UPDATE `mailboxes_update` SET `passwordCRYPT`=ENCRYPT(PP) where `username`=UU;
SELECT @salt:=CAST(SUBSTR(MD5(CAST(RAND() AS CHAR)),1,8) AS CHAR);
UPDATE `mailboxes_update` SET `passwordSSHA`= CONCAT('{SSHA}', SHA1(CONCAT(UU, @salt)), @salt) where `username`=UU;
RETURN OLD_PASSWORD(PP);
END$$
