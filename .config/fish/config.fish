if status is-interactive
    # Commands to run in interactive sessions can go here
    neofetch --kitty
end

# set PATH so it includes user's private ~/.local/bin if it exists
fish_add_path --path "$HOME/.local/bin"
fish_add_path --path "$HOME/go/bin"
fish_add_path --path "$HOME/.ghcup/bin"

# starship
starship init fish | source

# oh my fish settings
#set -g theme_display_git yes
#set -g theme_display_git_untracked yes
#set -g theme_display_git_ahead_verbose yes
#set -g theme_display_hg yes
#set -g theme_display_virtualenv no
#set -g theme_display_ruby yes
#set -g theme_display_user yes
#set -g theme_title_display_process yes
#set -g theme_title_display_path no
#set -g theme_date_format "+%a %H:%M"
#set -g theme_avoid_ambiguous_glyphs yes
#set -g default_user your_normal_user


### EXPORT ###
set fish_greeting # Supresses fish's intro message
set TERM screen-256color # Sets the terminal type
set EDITOR "emacsclient -t -a ''" # $EDITOR use Emacs in terminal
set VISUAL "emacsclient -c -a emacs" # $VISUAL use Emacs in GUI mode

### ALIASES ###
# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Changing "ls" to "exa"
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first' # all files and dirs
alias ll='exa -l --color=always --group-directories-first' # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Emacs
alias doom="$HOME/.emacs.d/bin/doom"
alias emt="emacsclient -t -a ''"
alias em="emacsclient -c -a emacs"

# Vim
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# bat
alias cat='bat'
alias man='batman'

# git
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'
alias gst='git status'

# config dotfiles
alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'

# npm
#alias npm='/usr/bin/pnpm'

# the terminal rickroll
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

# find with fzf
alias pfzf='rg --heading --line-number --column . | fzf --layout=reverse'
alias pfzff='rg --heading --line-number --column --files . | fzf --layout=reverse'

# pnpm
set -gx PNPM_HOME "/home/moritz/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# nvims
function old-nvim
    env NVIM_APPNAME=old-nvim nvim
end

function nvims
    set items old-nvim default
    set config (printf "%s\n" $items | fzf --prompt=" Neovim Config = " --height=~50% --layout=reverse --border --exit-0)
    if [ -z $config ]
        echo "Nothing selected"
        return 0
    else if [ $config = default ]
        set config ""
    end
    env NVIM_APPNAME=$config nvim $argv
end
