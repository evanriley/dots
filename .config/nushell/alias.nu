def dots [...args] {
  git --git-dir=($env.HOME)/.dotfiles/ --work-tree=($env.HOME) ...$args
}

alias vim = nvim
alias emacs = emacsclient

alias cd.. = cd ..
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ..... = cd ../../../../

alias cat = bat

alias clj-repl = clj "-J-Dclojure.server.repl={:port 5555 :accept clojure.core.server/repl :server-daemon false}"

