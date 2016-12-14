
APT Pinning
-----------

Source: https://www.debian.org/doc/manuals/apt-howto/ch-apt-get.de.html 

Formart: 
     Package: <Paket>
     Pin: <Pin-Definition>
     Pin-Priority: <Pin Priorty>

 Example:
----------

     Package: *
     Pin: release v=2.2*,a=stable,c=main,o=Debian,l=Debian
     Pin-Priority: 1001
 Pin Discription
 v= stand for point releases
 a= stand for Archiv
 c= stand for Sektion 
 o= source Label  Debian-Distribution
