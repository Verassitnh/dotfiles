# Aliases
## Command remaps
alias vim  'nvim'
alias grep  'grep --color=auto'
alias cat  'bat'
alias ls 'lsd'
alias less 'bat'
alias yay 'yay --color=auto'
## System
alias pacin 'sudo pacman -S' 
alias config  'nvim ~/.config/fish/config.fish'

## Helpful Shortcuts
alias b  'bpytop'
alias xmofig  'vim ~/.xmonad/xmonad.hs'


# Run Commands
export (dbus-launch)
neofetch

# Prompt
starship init fish | source

# EXPORTS
set fish_greeting
set -x BAT_THEME 'base16'
set -x CHROME_EXECUTABLE /usr/bin/brave-browser-nightly
