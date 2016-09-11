#/bin/bash
wget http://deic.uab.es/~iblanes/colorize-0.1-src.tar.gz
cd colorize
make
cp ./colorize /usr/local/bin/colorize
cd ..
