#!/bin/sh
#
# Shell Script To Run PHP5 using mod_fastcgi under Apache 2.x
#
# -------------------------------------------------------------------------
# Copyright (c) 2005 nixCraft project <http://cyberciti.biz/>
# This script is licensed under GNU GPL version 2.0 or above
# Comment/suggestion: <vivek@nixCraft.com>
# http://bash.cyberciti.biz/misc-shell/linux-start-stop-restar-toracle-server/
# -------------------------------------------------------------------------
     
### Set PATH ###
  PHP_CGI=/usr/local/bin/php-cgi
  PHP_FCGI_CHILDREN=4
  PHP_FCGI_MAX_REQUESTS=1000
### no editing below ###
  export PHP_FCGI_CHILDREN
  export PHP_FCGI_MAX_REQUESTS
  exec $PHP_CGI
