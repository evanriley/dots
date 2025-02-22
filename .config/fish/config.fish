set -g fish_greeting
set -gx EDITOR nvim
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx PATH ~/bin ~/.local/bin ~/go/bin ~/.config/emacs/bin ~/.atuin/bin ~/.roswell/bin ~/common-lisp/lem $PATH
set -x SSH_AUTH_SOCK ~/.gnupg/S.gpg-agent.ssh

alias vim nvim
alias emacs emacsclient

alias cd.. 'cd ..'
alias .. 'cd ..'
alias ... 'cd ../../../'
alias .... 'cd ../../../../'
alias ..... 'cd ../../../../'
alias .4 'cd ../../../../'
alias .5 'cd ../../../../..'

alias myip "curl -6 https://ifconfig.co; echo"

alias ls eza
alias cat bat
alias du dust

## fast clj repl
alias clj-repl 'clj "-J-Dclojure.server.repl={:port 5555 :accept clojure.core.server/repl :server-daemon false}"'

alias dots 'git --git-dir=$HOME/.dots/ --work-tree=$HOME'

# mise is an asdf replacement
mise activate fish | source

# use `z` to move around
zoxide init fish | source
