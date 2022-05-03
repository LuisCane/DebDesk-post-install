#Install VIM
InstallVIM () {
    printf '\nWould you like to install VIM? [y/n]'
    read -r yn
    case $yn in
        [Yy]* ) printf '\nInstalling VIM\n'
                sudo apt install -y vim
                check_exit_status;
                return 0;;
        [Nn]* ) printf '\nSkipping VIM'
                return 0;;
            * ) printf '\nPlease enter yes or no.\n'
                ;;
    esac
}