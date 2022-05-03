CPvimrc ()  {
    while true; do 
    read -p 'Would you like to copy the vimrc file included with this script to your home folder? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) cp ./home/user/vimrc ~/.vimrc
                    break;;
            [Nn]* ) printf '\nOK\n'
                    break;;
                * ) echo 'Please answer yes or no.';;
        esac
    done
}