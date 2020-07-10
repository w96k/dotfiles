# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

# if [[ $- != *i* ]]

#    # We are being invoked from a non-interactive shell.  If this
#    # is an SSH session (as in "ssh host command"), source
#    # /etc/profile so we get PATH and other essential variables.
#    [[ -n "$SSH_CLIENT" ]] && source /etc/profile

#    # Don't do anything else.
#    return
# fi

# Source the system-wide file.
source /etc/bashrc

# Adjust the prompt depending on whether we're in 'guix environment'.
if [ -n "$GUIX_ENVIRONMENT" ]
then
    export PS1="\w [env] \$"
else
    export PS1="\[$(tput bold; tput setaf 3;)\]\w \$ \[$(tput sgr0)\]"
fi
alias ls='ls -p --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'

# Welcome message
printf "Welcome to bash shell\n\n"

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/w96k/.sdkman"
[[ -s "/home/w96k/.sdkman/bin/sdkman-init.sh" ]] && source "/home/w96k/.sdkman/bin/sdkman-init.sh"
