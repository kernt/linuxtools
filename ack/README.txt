ack searches recursively by default, while ignoring .git, .svn, CVS and other VCS directories.

    # Which would you rather type?
    $ grep pattern $(find . -type f | grep -v '\.svn')

    $ ack pattern

Nice for development

Source:
http://beyondgrep.com/why-ack/

