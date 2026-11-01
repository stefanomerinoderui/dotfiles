# ~/.config/fish/config.fish

# If not running interactively, don't do anything (like early return in bash)
if not status is-interactive
    exit
end

# 1. Terminal-specific history for Zed
# Fish handles history via session names, saving to ~/.local/share/fish/zed_history
if test "$TERM_PROGRAM" = "zed"
    set -g fish_history zed
end

# NOTE: bash-complete-alias and ble.sh are removed. 
# Fish has built-in autosuggestions and natively handles alias completions.

bind \cl '/usr/bin/clear; commandline -f repaint'

# 2. Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias nano='nvim'
alias update='~/scripts/update_all.sh'
alias config='git --git-dir="$HOME/dotfiles/.git" --work-tree="$HOME/dotfiles"'
alias rsync='rsync --progress'
# Inline env variables in Fish aliases require 'env'
alias ministack='env AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test aws --endpoint-url=http://localhost:4566'
# Conda init script changed from .sh to .fish
alias load_conda='source /opt/miniconda3/etc/profile.d/conda.fish'

alias clearclear='/usr/bin/clear'
alias clear='echo "Casi, pero mejor CTRL + L"'

# 3. Environment Variables
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx TERMINAL alacritty
set -gx PAGER moor

# 4. PATH Additions
# fish_add_path automatically prevents duplicates and manages the $PATH list safely
fish_add_path $HOME/.scripts
set -gx PNPM_HOME "/home/stefano/.local/share/pnpm"
fish_add_path $PNPM_HOME/bin
fish_add_path /home/stefano/.local/share/gem/ruby/3.4.0/bin

# 5. Fastfetch execution
if type -q fastfetch; and test "$TERM_PROGRAM" != "vscode"; and test "$TERM_PROGRAM" != "zed"
    fastfetch
end

# 6. Integrations & Hooks
if test "$TERM_PROGRAM" = "kiro"
    source (kiro --locate-shell-integration-path fish)
end

if type -q direnv
    direnv hook fish | source
end

# OpenClaw Completion (Assuming a .fish version exists)
if test -f ~/.openclaw/completions/openclaw.fish
    source ~/.openclaw/completions/openclaw.fish
end

# NOTE: Home Manager bash vars cannot be sourced directly in Fish. 
# You either need to use a Fish port (like 'bass' or 'fenv') or check if Nix generates a fish hook.
# if test -r "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
#     bass source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
# end

# 7. Custom Functions (Replaces Bash Functions)
function explorer
    set fm $FILEMANAGER
    if test -z "$fm"
        set fm xdg-open
    end

    set path_arg $argv[1]
    if test -z "$path_arg"
        set path_arg .
    end

    # Expand tilde to home directory
    set path_arg (string replace -r '^~' "$HOME" $path_arg)

    if test -d "$path_arg"
        nohup $fm "$path_arg" > /dev/null 2>&1 &
    else
        echo "Error: '$path_arg' no es un directorio válido"
        return 1
    end
end

# 8. Conda PATH priority fix
# Fish handles $PATH as an array, making this much cleaner than Bash awk/sed.
for conda_dir in /opt/miniconda3/condabin /opt/miniconda3/bin
    if set -l index (contains -i $conda_dir $PATH)
        # Remove from current position and append to the end
        set -e PATH[$index]
        set -a PATH $conda_dir
    end
end

# OpenClaw Completion
test -f '/home/stefano/.openclaw/completions/openclaw.fish'; and source '/home/stefano/.openclaw/completions/openclaw.fish'
