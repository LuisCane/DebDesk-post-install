#Install Flatpaks
InstallFlatpaks () {
    printf 'Installing Flatpaks'
  file='./apps/flatpaks'

  while read -r line <&3; do
    printf 'Would you like to install %s [Y/n]? ' "$line"
    read -r yn
    yn=${yn:-Y}
    case $yn in
      [Yy]*) echo flatpak install -y "$line"
            flatpak install -y "$line"
             check_exit_status
             ;;
      [Nn]*) printf '\nSkipping %s\n' "$line";;
      *) break ;;
    esac
  done 3< "$file"
}