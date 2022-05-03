#Greet the user and warn not to use scripts without understanding them.
Greeting () {
    printf '\nHello!'
    sleep 1s
    printf '\nWelcome to my post installation script for Pop!_OS'
    sleep 1s
    printf '\nIt is not recommended that you run scripts that you find on the internet without knowing exactly what they do.\n\n
This script contains functions that require root privilages and is intended to run as root or with sudo. Running this script without root privilage will result in errors.\n'
    sleep 3s
    while true; do
        read -p $'Do you wish to proceed? [y/N]' yn
        yn=${yn:-N}
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
}