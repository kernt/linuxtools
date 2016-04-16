<? 

$testemail = "me@here.com";
$emailsubject = "Encrypted Information";
$emailfrom = "From: stranger@here.com;
$body = "-== Information to be Encrypted ==-\n\n";

//Tell gnupg where the key ring is. Home dir of user web server is running as.
putenv("GNUPGHOME=/var/www/.gnupg");

//create a unique file name
$infile = tempnam("/tmp", "PGP.asc");
$outfile = $infile.".asc";

//write form variables to email
$fp = fopen($infile, "w");
fwrite($fp, $body);
fclose($fp);

//set up the gnupg command. Note: Remember to put E-mail address on the gpg keyring.
$command = "/usr/bin/gpg -a --recipient 'Mini Me <me@here.com>' \\
--encrypt -o $outfile $infile";

//execute the gnupg command
system($command, $result);

//delete the unencrypted temp file
unlink($infile);

if ($result==0) {
	$fp = fopen($outfile, "r");
	
	if(!$fp||filesize ($outfile)==0) {
	  $result = -1;
	}


else {
	//read the encrypted file
	$contents = fread ($fp, filesize ($outfile));
	//delete the encrypted file
	unlink($outfile);


	//send the email
	mail ($testemail, $emailsubject, $contents, $emailfrom);

	print "<html>Thank you for your information. Your encrypted E-Mail has been sent.</html>";

     } 


}

if($result!=0) {
     print "<html>Their was a problem processing the informaion. Please contact <a href=\"mailto:webmaster@here.com\">webmaster@here.com</a>.";
}

?>
