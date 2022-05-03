#Install Sudo
InstallSudo () {
    printf '\nWould you like to install sudo [y/n]'
    read -r yn
    case $yn in
        [Yy]* ) printf '\nInstalling sudo\n'
                apt install -y sudo
                check_exit_status;
                return 0;;
        [Nn]* ) printf '\nSkipping sudo'
                return 0;;
            * ) printf '\nPlease enter yes or no.\n'
                ;;
    esac
}