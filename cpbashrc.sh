CPbashrcvimrc () {
    while true; do 
        read -p 'Would you like to copy the bashrc file included with this script to your home folder? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) rm ~/.bashrc && cp ./bashrc ~/.bashrc;;
            [Nn]* ) printf 'OK'
                    break;;
                * ) echo 'Please answer yes or no.';;
        esac
        read -p 'Would you like to copy the vimrc file included with this script to your home folder? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) rm ~/.bashrc && cp ./vimrc ~/.vimrc;;
            [Nn]* ) printf 'OK'
                    break;;
                * ) echo 'Please answer yes or no.';;
        esac
    done
}
CPbashrcvimrc
