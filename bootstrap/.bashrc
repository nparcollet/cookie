# Setup Prompt
export PS1="\[\e[32m\]bootstrap\[\e[m\] # "

# Setup Aliases
alias ls='ls --color'
alias ll='ls --color -la'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# Configure Terminal
shopt -s checkwinsize

# Setup path
export PATH=.:/opt/bin/cookie:$PATH

# Source Custom Environment Information
[ -d /root/profile.d ] && for e in $(ls /root/profile.d/*.env); do echo "Sourcing ${e}"; . ${e}; done

