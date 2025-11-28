# Hyprland Fish Configuration
# Source this file from your ~/.config/fish/config.fish:
# test -f ~/.config/fish/hyprland.fish; and source ~/.config/fish/hyprland.fish

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# ============================================================================
# Prompt
# ============================================================================

starship init fish | source

# ============================================================================
# Aliases
# ============================================================================

alias vi nvim

# Kitty SSH
alias ssk="kitty +kitten ssh"

# Image viewer in kitty
alias icat="kitty +kitten icat"

# Git log aliases
alias log1="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias log2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"

# ============================================================================
# fzf Integration
# ============================================================================

fzf --fish | source

# ============================================================================
# Key Bindings
# ============================================================================

# Alt-backspace to delete path component
bind alt-backspace backward-kill-path-component

# ============================================================================
# Conda Configuration (Optional - Lazy Loading)
# ============================================================================

# Set conda path if you have conda installed
# set -x CONDA_PATH ~/miniconda3/bin/conda

# Lazy-load conda initialization for faster shell startup
# function conda
#     echo "Lazy loading conda upon first invocation..."
#     # Erase the existing conda function to avoid recursion
#     functions --erase conda
#
#     # Find the first existing conda executable and initialize its shell hook
#     for conda_path in $CONDA_PATH
#         if test -f $conda_path
#             echo "Using Conda installation found in $conda_path"
#             eval $conda_path "shell.fish" hook | source
#             # Now call conda with the original arguments
#             conda $argv
#             return
#         end
#     end
#     echo "No conda installation found in $CONDA_PATH"
# end

# Set up basic conda completions without full initialization
# complete -c conda -f
# complete -c conda -n __fish_use_subcommand -a 'activate deactivate install uninstall list create remove env info search update config clean'
# complete -c conda -n '__fish_seen_subcommand_from activate' -a '(test -d ~/miniconda3/envs; and ls ~/miniconda3/envs 2>/dev/null)'
