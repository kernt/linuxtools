#!/bin/sh
# Soure : https://wiki.archlinux.de/title/SSH-Authentifizierung_mit_Schl%C3%BCsselpaaren
#
envfile="${HOME}/.gnupg/gpg-agent.env"
if test -f "$envfile" && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
    eval "$(cat "$envfile")"
else
    eval "$(gpg-agent --enable-ssh-support --daemon --write-env-file "$envfile")"
fi
