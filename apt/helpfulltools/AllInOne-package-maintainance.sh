#!/bin/bash
# AllInOne: Update what packages are available, upgrade to new versions, remove unneeded packages
# (some are no longer needed, replaced by the ones from ap upgrade), check for dependencies
# and clean local cached packages (saved on disk but not installed?,some are needed? [this only cleans unneeded unlike ap clean]).

# aliases (copy into ~/.bashrc file):
alias a='alias'
a ap='apt-get'
a r='ap autoremove -y'
a up='ap update'
a u='up && ap upgrade -y --show-progress && r && ap check && ap autoclean'
# && means "and run if the previous succeeded", you can change it to ; to "run even if previous failed".

I'm not sure if ap check should be before or after ap upgrade -y, you can also change the alias names.

# To expand aliases in bash use ctrl alt e or see this ow.ly/zBKHs
# For more useful aliases go to ow.ly/zBMOx

apt-get update && apt-get dist-upgrade -y --show-progress && apt-get autoremove -y && apt-get check && apt-get autoclean -y
