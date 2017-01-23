# Quelle http://stackoverflow.com/questions/1057343/how-do-i-automatically-set-the-display-variable-for-my-current-session
function get_xserver ()
{
    case $TERM in
       xterm )
            XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' )    
            XSERVER=${XSERVER%%:*}
            ;;
        aterm | rxvt)           
            ;;
    esac  
}

if [ -z ${DISPLAY:=""} ]; then
    get_xserver
    if [[ -z ${XSERVER}  || ${XSERVER} == $(hostname) || \
      ${XSERVER} == "unix" ]]; then 
        DISPLAY=":0.0"          # Display on local host.
    else
        DISPLAY=${XSERVER}:0.0  # Display on remote host.
    fi
fi

export DISPLAY
