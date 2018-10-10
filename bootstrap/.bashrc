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

# Cookie Environment
export COOKIE=/opt/cookie
export COOKIE_ENV=1
export PYTHONPATH=${COOKIE}/python
export PYTHONDONTWRITEBYTECODE=1

# Setup path
PATH=.
PATH=$PATH:/sbin
PATH=$PATH:/usr/sbin
PATH=$PATH:/bin
PATH=$PATH:/usr/bin
PATH=$PATH:/usr/local/sbin
PATH=$PATH:/usr/local/bin
PATH=$PATH:/opt/target/toolchain/bin
PATH=$PATH:$COOKIE/bin
export PATH

# Source Custom Environment Information
[ -d /root/profile.d ] && for e in $(ls /root/profile.d/*.env); do echo "Sourcing ${e}"; . ${e}; done

