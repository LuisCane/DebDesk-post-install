#Install apt packages
InstallAptSW() {
    printf 'Installing Apt Packages\n'
    sleep 1s
  file='./apps/apt-apps'

  while read -r line <&3; do
    printf 'Would you like to install %s [Y/n]? ' "$line"

    read -r yn
    yn=${yn:-Y}
    case $yn in
      [Yy]*) echo apt install -y "$line" 
            apt install -y "$line"
            check_exit_status
            ;;
      [Nn]*) printf '\nSkipping %s\n' "$line";;
      *) break ;;
    esac
  done 3< "$file"
}