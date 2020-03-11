# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

if [[ $- != *i* ]]
then
    # We are being invoked from a non-interactive shell.  If this
    # is an SSH session (as in "ssh host command"), source
    # /etc/profile so we get PATH and other essential variables.
    [[ -n "$SSH_CLIENT" ]] && source /etc/profile

    # Don't do anything else.
    return
fi

# Source the system-wide file.
source /etc/bashrc

function color_prompt {
    local __user_and_host="\[\033[01;35m\]\u"
    local __cur_location="\[\033[01;34m\]\w"
    local __git_branch_color="\[\033[01;36m\]"
    #local __git_branch="\`ruby -e \"print (%x{git branch 2> /dev/null}.grep(/^\*/).first || '').gsub(/^\* (.+)$/, '(\1) ')\"\`"
    local __git_branch='`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`'
    local __prompt_tail="\[\033[30m\]$"
    local __last_color="\[\033[00m\]"
    local __guix_env="\[\033[01;32m\][env]"
    if [ -n "$GUIX_ENVIRONMENT" ]
    then
	export PS1="$__user_and_host $__cur_location $__git_branch_color$__git_branch$__guix_env $__prompt_tail$__last_color "
    else
	export PS1="$__user_and_host $__cur_location $__git_branch_color$__git_branch$__prompt_tail$__last_color "
    fi
}

color_prompt


set colored-stats on

# Adjust the prompt depending on whether we're in 'guix environment'.
