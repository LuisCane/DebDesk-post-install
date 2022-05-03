#Install Snap Packages
InstallSnaps () {
    printf 'Installing Snaps'
  file='./apps/snaps'

  while read -r line <&3; do
    printf 'Would you like to install %s [Y/n]? ' "$line"
    read -r yn
    yn=${yn:-Y}
    case $yn in
      [Yy]*) echo snap install -y "$line"
            snap install "$line"
             check_exit_status
             ;;
      [Nn]*) printf '\nSkipping %s\n' "$line";;
      *) break ;;
    esac
  done 3< "$file"
}