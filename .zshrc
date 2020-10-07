#
#  ██  ███        ██                   ██                    
#  ░░███░░██      ██                   ░██                    
#   ░░░  ░░      ██      ██████  ██████░██      ██████  █████ 
#               ██      ░░░░██  ██░░░░ ░██████ ░░██░░█ ██░░░██
#              ██          ██  ░░█████ ░██░░░██ ░██ ░ ░██  ░░ 
#             ██      ██  ██    ░░░░░██░██  ░██ ░██   ░██   ██
#            ██      ░██ ██████ ██████ ░██  ░██░███   ░░█████ 
#           ░░       ░░ ░░░░░░ ░░░░░░  ░░   ░░ ░░░     ░░░░░  
# 
# Copywrite (c) 2020 Jackson Mooring
#  - https://github.com/Verassitnh
#  - https://jacksonmooring.com
#
# A customized config file for zsh (https://zsh.org/)
#
# Technologies Used:
#  - neofetch (https://github.com/dylanaraps/neofetch)
#  - lsd (https://github.com/Peltoche/lsd)
#  - ohmyzsh (https://github.com/ohmyzsh/ohmyzsh)
#  - powerlevel10k (https://github.com/romkatv/powerlevel10k)
#  - fzf (https://github.com/junegunn/fzf)
#  - chroma (https://github.com/alecthomas/chroma)
#  - nvm (https://github.com/nvm-sh/nvm)
#  - zsh-autosuggestions (https://github.com/zsh-users/zsh-autosuggestions)
#  - zsh-syntax-highlighting (https://github.com/zsh-users/zsh-syntax-highlighting)
#  - zsh-history-substring-search (https://github.com/zsh-users/zsh-history-substring-search)
#  - zsh-completions (https://github.com/zsh-users/zsh-completions)

# EXPORT PATH
export PATH=$PATH:~/.local/bin

# ZSH LOCATION
export ZSH="/home/verassitnh/.oh-my-zsh"

# ALIASES

# Command remaps
alias ls='lsd'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias cat="bat"
alias vim="nivm"

# Helpful Shortcuts
alias b="bpytop"
alias pacout="sudo pacman -Rs"
alias ip='ip a'

# Arch Linux
alias browspac="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
alias mirrorUpdate='sudo reflector --latest 250 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'

# ls shortcuts
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'


# SET CONFIG VARS
ZSH_ALIAS_FINDER_AUTOMATIC=true
ENABLE_CORRECTION=true

export BAT_THEME=base16

# LOAD PLUGINS
plugins=(
	zsh-history-substring-search
	zsh-autosuggestions
	zsh-completions
	zsh-syntax-highlighting
	git
	command-not-found
	zsh-interactive-cd
	sudo
	alias-finder
	archlinux
	golang
)

unalias glog

#FUNCTIONS

pclist() {
	pacman -Qi | awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' | sort -h
}

lazygit() {
    git status .
    git add .
    git commit -m "$@"
    git push origin HEAD
}

glog() {
    setterm -linewrap off

    git --no-pager log --all --color=always --graph --abbrev-commit --decorate \
        --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' | \
        sed -E \
            -e 's/\|(\x1b\[[0-9;]*m)+\\(\x1b\[[0-9;]*m)+ /├\1─╮\2/' \
            -e 's/(\x1b\[[0-9;]+m)\|\x1b\[m\1\/\x1b\[m /\1├─╯\x1b\[m/' \
            -e 's/\|(\x1b\[[0-9;]*m)+\\(\x1b\[[0-9;]*m)+/├\1╮\2/' \
            -e 's/(\x1b\[[0-9;]+m)\|\x1b\[m\1\/\x1b\[m/\1├╯\x1b\[m/' \
            -e 's/╮(\x1b\[[0-9;]*m)+\\/╮\1╰╮/' \
            -e 's/╯(\x1b\[[0-9;]*m)+\//╯\1╭╯/' \
            -e 's/(\||\\)\x1b\[m   (\x1b\[[0-9;]*m)/╰╮\2/' \
            -e 's/(\x1b\[[0-9;]*m)\\/\1╮/g' \
            -e 's/(\x1b\[[0-9;]*m)\//\1╯/g' \
            -e 's/^\*|(\x1b\[m )\*/\1⎬/g' \
            -e 's/(\x1b\[[0-9;]*m)\|/\1│/g' \
        | command less -r +'/[^/]HEAD'

    setterm -linewrap on
}

# COMMANDS
neofetch

# EXPORT VARIABLES
export ARCHFLAGS="-arch x86_64"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8

# LOAD NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# LOAD POWERLEVEL10K
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

# LOAD OH-MY-ZSH
source $ZSH/oh-my-zsh.sh
