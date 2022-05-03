#Update and Upgrade system packages
Update () {
    while true; do
        read -p $'Would you like to update the repositories? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) apt update; check_exit_status; break;;
            [Nn]* ) break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
    while true; do
        read -p $'Would you like to upgrade the software? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) apt-pkg-upgrade;
                    check_exit_status
                    break;;
            [Nn]* ) break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
    while true; do
        read -p $'Would you like to update flatpaks? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) flatpak update; break;;
            [Nn]* ) break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
    while true; do
        read -p $'Would you like to update the firmware? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) fwupdmgr get-devices;
                    check_exit_status;
                    fwupdmgr get-updates;
                    check_exit_status;
                    return 0;;
            [Nn]* ) break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
}
#upgrade Apt Packages
apt-pkg-upgrade () {
    printf '\napt -y upgrade\n'
    apt -y upgrade --allow-downgrades;
    check_exit_status
    printf '\napt -y dist-upgrade\n'
    apt -y dist-upgrade;
    check_exit_status
    printf '\napt -y autoremove\n'
    apt -y autoremove;
    check_exit_status
    printf '\napt -y autoclean\n'
    apt -y autoclean;
    check_exit_status
}