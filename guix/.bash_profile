# Add npm to PATH
export PATH="~/.nodejs/bin/:$PATH"

# Add .bin to PATH
export PATH="~/.bin/:$PATH"

# Add ruby gems to PATH
export PATH=$PATH:/home/w96k/.gem/
export PATH=$PATH:/home/w96k/.gem/ruby/2.5.0/bin/

# Add nix to PATH
export PATH=$PATH:/nix/var/nix/profiles/default/bin/

# Add custom packages to guix PATH
export GUIX_PACKAGE_PATH=~/.guix-packages

export TERM=rxvt

setxkbmap -layout us,ru -option grp:caps_toggle

#Shepherd (with emacs daemon)
shepherd &

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"                  # $EDITOR opens in terminal
export VISUAL="emacsclient -c -a emacs"         # $VISUAL opens in GUI mode

if [ -f .bashrc ]
then
    . .bashrc
fi
