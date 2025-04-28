let OS = sys host | get long_os_version

if ($OS | str contains "Linux") {
  $env.PATH = ($env.PATH | split row (char esep) | append '/home/evan/bin')
  $env.PATH = ($env.PATH | split row (char esep) | append '/home/evan/.local/bin')
  $env.PATH = ($env.PATH | split row (char esep) | append '/home/evan/go/bin')
  $env.PATH = ($env.PATH | split row (char esep) | append '/home/evan/.cargo/bin')
}

$env.GPG_TTY = (tty) 
$env.SSH_AUTH_SOCK = (gpgconf --list-dirs agent-ssh-socket | str trim)

def add-ssh-keys [] {
    # Run in background with retry logic using bash, redirecting all output including nohup's
    ^bash -c 'nohup bash -c "
        # Try up to 30 times (3 seconds total)
        for i in {1..30}; do
            if [ -S \"$XDG_RUNTIME_DIR/ssh-agent.socket\" ]; then
                # Check if keys are already added
                if ! ssh-add -l &>/dev/null; then
                    # Redirect both stdout and stderr to suppress all messages
                    ssh-add ~/.ssh/id_ed25519_yubikey &>/dev/null
                fi
                exit 0
            fi
            sleep 0.1
        done
    " >/dev/null 2>&1 &'
}

# Start the background process
do { add-ssh-keys }

# remove duplicate paths
$env.PATH = ($env.PATH | uniq)

mkdir ~/.cache/starship
zoxide init nushell | save -f ~/.zoxide.nu
mise activate nu | save -f ~/.cache/mise/init.nu
starship init nu | save -f ~/.cache/starship/init.nu
