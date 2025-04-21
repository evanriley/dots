#!/usr/bin/env bash

# Stop script on first error
set -e

# --- Configuration ---
repo_url="https://github.com/evanriley/dots.git"
# Location for the bare repository
dotfiles_dir="$HOME/.dotfiles"
# Bash config file to add the alias to
bash_config_file="$HOME/.bashrc"
# The alias definition string
alias_definition="alias dots='git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'"
# --- End Configuration ---

# --- Helper Functions ---
# Temporary function to mimic the 'dots' alias during script execution
dots() {
  git --git-dir="$dotfiles_dir" --work-tree="$HOME" "$@"
}

# --- Main Script ---

echo "Starting dotfiles setup..."

# Check if the repository URL placeholder has been replaced
if [ "$repo_url" = "YOUR_GIT_REPO_URL_HERE" ]; then
    echo >&2 "Error: Please download this script, edit it, and replace 'YOUR_GIT_REPO_URL_HERE' with your actual dotfiles repository URL."
    echo >&2 "You cannot run the template directly from curl."
    exit 1
fi

# Check if the target directory already exists
if [ -d "$dotfiles_dir" ]; then
    echo >&2 "Error: Dotfiles directory already exists at $dotfiles_dir"
    echo >&2 "Please remove it or choose a different location if you want to re-clone."
    exit 1
fi

# Clone the bare repository
echo "Cloning dotfiles repository from $repo_url to $dotfiles_dir..."
git clone --bare "$repo_url" "$dotfiles_dir"

# Attempt to checkout the dotfiles
echo "Attempting to check out dotfiles into $HOME..."
if dots checkout; then
    echo "Checkout successful."
else
    echo "---------------------------------------------------------------------" >&2
    echo "Warning: Checkout failed. This often means existing files in $HOME conflict with your dotfiles." >&2
    echo "Conflicting files are listed above (stderr)." >&2
    echo "You might need to manually back up or remove conflicting files." >&2
    echo "After resolving conflicts, you can try running checkout again manually using the 'dots' alias (after restarting your shell or sourcing $bash_config_file):" >&2
    echo "  dots checkout" >&2
    echo "Or force the checkout (use with caution, overwrites existing files):" >&2
    echo "  dots checkout -f" >&2
    echo "---------------------------------------------------------------------" >&2
    # Continue setup despite checkout issues
fi

# Configure the local repository to hide untracked files
echo "Configuring repository to hide untracked files (git status)..."
dots config --local status.showUntrackedFiles no

echo ""
echo "Dotfiles setup process complete."
echo "If there were checkout warnings, please resolve them manually."
echo "Remember to restart your shell or run 'source $bash_config_file' to activate the 'dots' alias."
