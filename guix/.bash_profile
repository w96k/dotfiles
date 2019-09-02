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

# Proxy
#export http_proxy=socks5://127.0.0.1:9050
#export https_proxy=$http_proxy

export TERM=rxvt

setxkbmap -layout us,ru -option grp:caps_toggle

if [ -f .bashrc ]
then
    . .bashrc
fi
