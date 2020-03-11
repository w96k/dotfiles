# Add guix path
export GUIX_PROFILE="$HOME/.guix-profile" ; \
source "$HOME/.guix-profile/etc/profile"

export GUIX_LOCPATH=$HOME/.guix-profile/lib/locale

# Add npm to PATH
export PATH="$PATH:~/.nodejs/bin/"

# Add .bin to PATH
export PATH="~$PATH:/.bin/"

export PATH="$PATH:~/.local/bin/"
export PATH="$PATH:~/usr/local/bin/"

# Add ruby gems to PATH
export PATH=$PATH:/home/w96k/.gem/
export PATH=$PATH:/home/w96k/.gem/ruby/2.5.0/bin/

#sh export GDK_CORE_DEVICE_EVENTS=1

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"                  # $EDITOR opens in terminal
export VISUAL="emacsclient -c -a emacs" # $VISUAL opens in GUI mode

#[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
#    . /usr/share/bash-completion/bash_completion

# Colored ls
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'

alias python='python3'
