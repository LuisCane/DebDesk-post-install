#install Refind for Dualboot systems.
InstallRefind () {
    printf '\nIf this is a Dual Boot system, Refind is a nice graphical bootloader.\nWould you like to install rEFInd? [y/n]'
    read -r yn
    case $yn in
        [Yy]* ) printf '\nInstalling rEFInd\n'
                sudo apt install -y Refind
                check_exit_status;
                return 0;;
        [Nn]* ) printf '\nSkipping rEFIndt\n'
                return 0;;
            * ) printf '\nPlease enter yes or no.\n'
                ;;
    esac
}