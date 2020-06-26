#!/usr/bin/zsh
# source each zsh config file

# source zsh config
source "${ZDOTDIR}/env_config.zsh" # History/Application configuration
source "${ZDOTDIR}/prompt.zsh"     # prompt configuration
source "${ZDOTDIR}/functions.zsh"  # functions, bindings, command completion
source "${ZDOTDIR}/completion.zsh" # zsh completion
source "${ZDOTDIR}/lazy.zsh"       # lazy load shell tools

# source aliases
ALIAS_DIR="${ZDOTDIR}/aliases"
source "${ALIAS_DIR}/aliases"           # General aliases
source "${ALIAS_DIR}/git_aliases"       # Git aliases (from oh-my-zsh)
source "${ALIAS_DIR}/personal_aliases"  # Personal Aliases (e.g. ssh to servers)
source "${ALIAS_DIR}/directory_aliases" # Directory Aliases (shortcuts to jump to directories)

# zsh plugins
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/doc/pkgfile/command-not-found.zsh
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
