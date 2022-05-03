#Set up Yubikey authentication
ConfigYubikeys () {
    while true; do
        read -p $'Would you like to set up Yubikey authentication? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) InstallYubiSW;
                    CreateYubikeyOTP;
                    CreateYubikeyChalResp;
                    CPYubikeyFiles;
                    return 0;;
            [Nn]* ) printf "\nSkipping Yubikey setup\n";
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
}
#Install Yubico Software
InstallYubiSW () {
    printf '\napt install -y libpam-yubico\n'
    sudo apt install -y libpam-yubico;
    check_exit_status
    printf '\napt install -y libpam-u2f\n'
    sudo apt install -y libpam-u2f;
    check_exit_status
    printf '\napt install -y yubikey-manager\n'
    sudo apt install -y yubikey-manager;
    check_exit_status
    printf '\napt install -y yubikey-personalization\n'
    sudo apt install -y yubikey-personalization;
    check_exit_status
}
#Setup Yubikey Challenge Response Authentication
CreateYubikeyChalResp () {
    echo -e "\nSetting up Challenge Response Authentication\n"
    read -rsn1 -p "Please insert your yubikey and press any key to continue"
    echo -e '\nWARNING IF YOU HAVE ALREADY PROGRAMED CHALLENGE RESPONSE, THIS STEP WILL OVERWRITE YOUR EXISTING KEY WITH A NEW ONE. SKIP THIS STEP IF YOU DO NOT WANT A NEW KEY!\n'
    sleep 1s
    while true; do
        read -p "Would you like to program challenge reponse keys on your yubikey? [y/N]" yn
        yn=${yn:-n}
        case $yn in
        [Yy]* ) echo 'ykpersonalize -2 -ochal-resp -ochal-hmac -ohmac-lt64 -oserial-api-visible'
                ykpersonalize -2 -ochal-resp -ochal-hmac -ohmac-lt64 -oserial-api-visible ;
                while true; do
                    read -p "Would you like to program challenge reponse keys on another yubikey? [y/N]" yn
                    yn=${yn:-N}
                    case $yn in
                    [Yy]* ) read -rsn1 -p "Please insert your next yubikey and press any key to continue"
                            echo 'ykpersonalize -2 -ochal-resp -ochal-hmac -ohmac-lt64 -oserial-api-visible'
                            ykpersonalize -2 -ochal-resp -ochal-hmac -ohmac-lt64 -oserial-api-visible;;
                    [Nn]* ) break;;
                    * ) echo 'Please answer yes or no.';;
                    esac
                done;;
        [Nn]* ) break;;
        * ) echo 'Please answer yes or no.';;
        esac
    done
    echo -e "\nNow creating Yubikey Challenge Response files.\n"
    sleep 1s
    while true; do
        echo "ykpamcfg -2 -v"
        ykpamcfg -2 -v
        read -p "Would you like to add another yubikey? [Y/n]" yn
        yn=${yn:-Y} 
        case $yn in
        [Yy]* ) read -rsn1 -p "Please insert your next yubikey and press any key to continue"
                echo "ykpamcfg -2 -v"
                ykpamcfg -2 -v;;
        [Nn]* ) printf "\nSkipping\n";
                break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
    
}
#Setup Yubikey OTP Authentication
CreateYubikeyOTP () {
    echo -e "\nSetting up OTP Authentication\n"
    sleep 1s
    authykeys=$USER
    read -p "Please touch your yubikey: " ykey
    ykey12=${ykey:0:12}
    authykeys+=':'
    authykeys+=$ykey12
    while true; do
        read -p "Would you like to add another yubikey? [Y/n]" yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) read -s -p "Please touch your next yubikey: " ykey
    	            ykey12=${ykey:0:12}
                    authykeys+=':'
                    authykeys+=$ykey12;;
            [Nn]* ) printf "\nSkipping\n";
                    echo $authykeys | tee >> ./authorized_yubikeys;
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
        echo $authykeys | tee >> ./authorized_yubikeys
        echo "Keys saved to ./authorized_yubikeys."
    done
}
#Copy and move Yubikey files to apropriate locations
CPYubikeyFiles () {
    printf "mkdir -p /var/yubico\n"
    mkdir -p /var/yubico
    printf "chown root:root /var/yubico\n"
    chown root:root /var/yubico
    printf "chmod 766 /var/yubico\n"
    chmod 766 /var/yubico
    printf "cp ./authorized_yubikeys /var/yubico/authorized_yubikeys\n"
    cp ./authorized_yubikeys /var/yubico/authorized_yubikeys
    for i in ~/.yubico/*; do
        printf "cp $i $(echo $i | sed "s/challenge/$USER/")\n"
        cp $i $(echo $i | sed "s/challenge/$USER/")
        printf "mv ~/.yubico/$USER* /test/var/yubico/\n"
        mv ~/.yubico/$USER* /test/var/yubico/
        printf "chown root:root /test/var/yubico/*\n"
        chown root:root /test/var/yubico/*
        printf "chmod 600 /test/var/yubico/*\n"
        chmod 600 /test/var/yubico/*
    done
    printf "chmod 700 /var/yubico"
    chmod 700 /var/yubico
    printf "cp ./pam.d/yubikey /etc/pam.d/yubikey"
    cp ./pam.d/yubikey /etc/pam.d/yubikey
    printf "cp ./pam.d/yubikey-sudo /etc/pam.d/yubikey-sudo"
    cp ./pam.d/yubikey-sudo /etc/pam.d/yubikey-sudo
    printf "cp ./pam.d/yubikey-pin /etc/pam.d/yubikey-pin"
    scp ./pam.d/yubikey-pin /etc/pam.d/yubikey-pin
    printf "\nAdd 'include' statements to pam auth files to specify your security preferences."
    sleep 3s

}