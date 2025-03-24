# Setup

```bash
# Install chezmoi if not already available
# On Fedora/RHEL-based:
# rpm-ostree install chezmoi
# or
# dnf install chezmoi
# or
# sh -c "$(curl -fsLS get.chezmoi.io)"

# Initialize chezmoi with this repository
chezmoi init https://github.com/evanriley/dots.git

# Review what changes would be made
chezmoi diff

# Apply the dotfiles to your system
chezmoi apply
```

## Common Commands

```bash
# Edit a dotfile (this automatically updates the source repository)
chezmoi edit ~/.bashrc

# Add a new file to be managed by chezmoi
chezmoi add ~/.config/some-config-file

# Pull latest changes from the repository and apply them
chezmoi update

# See what files chezmoi is managing
chezmoi managed

# Remove a file/directory from chezmoi management
# (keeps the actual file in your home directory)
chezmoi forget ~/.config/some-directory
```

## Git Integration

Chezmoi automatically handles git operations. After making changes:
```bash
# Navigate to the chezmoi source directory
chezmoi cd

# View status of the git repository
git status

# Manually commit and push changes
git add .
git commit -m "Update dotfiles"
git push
```

This repository preserves historical data from previous dotfiles management approaches. The ```old-dotfiles``` branch contains the pre-chezmoi setup for reference.
