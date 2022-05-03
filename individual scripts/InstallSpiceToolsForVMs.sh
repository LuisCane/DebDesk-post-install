#Install Spice tools for VMs
InstallSpiceVDAgent () {
    printf '\nIf this is a QEMU/Spice Virtual Machine, installing the Spice Tools is recommended.\nWould you like to install Spice-vdagent? [y/n]'
    read -r yn
    case $yn in
        [Yy]* ) printf '\nInstalling spice-vdagent\n'
                sudo apt install -y spice-vdagent
                check_exit_status;
                return 0;;
        [Nn]* ) printf '\nSkipping Spice-VDagent\n'
                return 0;;
            * ) printf '\nPlease enter yes or no.\n'
                ;;
    esac
}