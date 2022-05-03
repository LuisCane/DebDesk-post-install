#Install Software
InstallSW () {
    while true; do
    read -p $'Would you like to install apt packages? [Y/n]' yn
    yn=${yn:-Y}
    case $yn in
        [Yy]* ) InstallAptSW
                break
                ;;
        [Nn]* ) printf "\nSkipping apt packages\n";
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done

    while true; do
        read -p $'Would you like to install Flatpaks? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
        [Yy]* ) apt install flatpak
                InstallFlatpaks
                break
                ;;
        [Nn]* ) printf "\nSkipping Flatpaks\n";
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done

    while true; do
        read -p $'Would you like to install snap packages? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
        [Yy]* ) echo 'apt install snapd\n'
                apt install snapd
                InstallSnaps
                break
                ;;
        [Nn]* ) printf "\nSkipping Snaps\n";
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done

    while true; do
        printf $'Would you like to install Firestorm Viewer? [Y/n]'
        read -r yn
        yn=${yn:-Y}
        case $yn in
        [Yy]* ) echo 'Installing Firestorm'
                read -rsn1 -p "Please ensure that the download link in ./apps/firestorm is the latest version. Press any key to continue."
                InstallFirestorm
                break
                ;;
        [Nn]* ) printf "\nSkipping Firestorm\n";
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
}