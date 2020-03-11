# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[magenta]%}%n %{$fg[blue]%}%~ %{$fg[grey]%}$%{$reset_color%}%b "

#PS1="%B%{$fg[magenta]%}%n"
#PS1="%B%{$fg[red]%}"
#PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.
