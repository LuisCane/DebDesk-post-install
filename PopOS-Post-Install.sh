#!/bin/bash

#Common Setup after installing PopOS.
#Part 1 - Update & Upgrade software and install vim
#   apt
#   firmware
#   flatpak
#   install vim
#Part 2 - Change common settings
#   Hostname
#   SSH Keys
#   edit .bashrc
#   
#Part 3 - Set up Yubikey and PAM
#Part 4 - Install Software
#   Apt:
#       neofetch
#       code
#       openssh-server
#       Gnome-tweaks
#       Gparted
#       snapd
#       vlc
#       putty
#       variety
#       steam
#       lutris
#       cool-retro-term
#       tilix
#       virtviewer
#       spicevdagent (VMs Only)
#   Flatpak:
#       flatseal
#       onlyoffice
#       masterpdf
#       krita
#       pulseeffects
#   Snap:
#       snapstore
#   Other:
#       firestorm viewer
#Part 5 - Reminder of additional setup   

Greeting () {
    printf '\nHello!'
    sleep 1s
    printf '\nWelcome to my post installation script for Pop!_OS'
    sleep 1s
    printf '\nIt is not recommended that you run scripts that you find on the internet without knowing exactly what they do.\n\n
This script contains functions that require root privilages.\n'
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
#Update and Upgrade system packages
Update () {
    while true; do
        read -p $'Would you like to update the repositories? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) sudo apt update; check_exit_status; break;;
            [Nn]* ) break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
    while true; do
        read -p $'Would you like to upgrade the software? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) apt-pkg-upgrade; break;
                    sudo apt install vim;;
            [Nn]* ) break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
    while true; do
        read -p $'Would you like to update flatpaks? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) sudo flatpak update; break;;
            [Nn]* ) break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
    while true; do
        read -p $'Would you like to update the firmware? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) sudo fwupdmgr get-devices;
                    check_exit_status;
                    sudo fwupdmgr get-updates;
                    check_exit_status;
                    return 0;;
            [Nn]* ) break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
}
#upgrade Apt Packages
apt-pkg-upgrade () {
    printf '\nsudo apt -y upgrade\n'
    sudo apt -y upgrade;
    check_exit_status
    printf '\nsudo apt -y dist-upgrade\n'
    sudo apt -y dist-upgrade;
    check_exit_status
    printf '\nsudo apt -y autoremove\n'
    sudo apt -y autoremove;
    check_exit_status
    printf '\nsudo apt -y autoclean\n'
    sudo apt -y autoclean;
    check_exit_status
}
#Change System Hostname
ChHostname () {
    while true; do
        printf "\nYour System Hostname is $HOSTNAME \n"
        read -p $'Would you like to change the hostname? [y/N]' yn
        yn=${yn:-N}
        case $yn in
            [Yy]* ) read -p "Please enter a new Hostname: " NEWHOSTNAME;
                    sudo hostnamectl set-hostname $NEWHOSTNAME
                    return 0;;
            [Nn]* ) echo
                    echo "Hostname " $HOSTNAME " will not be changed.";
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
}
#Generate SSH Key with comment
SSHKeyGen () {
    while true; do
        read -p $'Would you like to generate an SSH key? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) read -p "Please enter a type [RSA/dsa]: " keytype;
                    keytype=${keytype:-RSA}
                    read -p "Please enter a modulus [4096]: " modulus;
                    modulus=${modulus:-4096}
                    read -p "Enter a comment to help identify this key [$USER @ $HOSTNAME]: " keycomment;
                    keycomment=${keycomment:-$USER @ $HOSTNAME}
                    read -p "Enter an output file [$HOME/.ssh/$USER\_rsa]: " outfile;
                    outfile=${outfile:-$HOME/.ssh/$USER\_rsa}
                    ssh-keygen -t $keytype -b $modulus -C "$keycomment" -f $outfile;
                    return 0;;
            [Nn]* ) printf "\nSSH Key Not generated";
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
}
#Copy bashrc and vimrc to home folder
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
            [Nn]* ) printf "\nSkipping Yubikey setup";
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
}
#Install Yubico Software
InstallYubiSW () {
    printf '\nsudo apt install -y libpam-yubico\n'
    sudo apt install -y libpam-yubico;
    check_exit_status
    printf '\nsudo apt install -y libpam-u2f\n'
    sudo apt install -y libpam-u2f;
    check_exit_status
    printf '\nsudo apt install -y yubikey-manager\n'
    sudo apt install -y yubikey-manager;
    check_exit_status
    printf '\nsudo apt install -y yubikey-personalization\n'
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
        [Yy]* ) echo 'ykpersonalize -2 -ochal-resp -ochal-hmac -ohmac-lt64 -oserial-api-visible';
                while true; do
                    read -p "Would you like to program challenge reponse keys on another yubikey? [y/N]" yn
                    yn=${yn:-N}
                    case $yn in
                    [Yy]* ) read -rsn1 -p "Please insert your next yubikey and press any key to continue"
                            echo 'ykpersonalize -2 -ochal-resp -ochal-hmac -ohmac-lt64 -oserial-api-visible';;
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
        read -p "Would you like to add another yubikey? [Y/n]" yn
        yn=${yn:-Y} 
        case $yn in
        [Yy]* ) read -rsn1 -p "Please insert your next yubikey and press any key to continue"
                echo "ykpamcfg -2 -v";;
        [Nn]* ) printf "\nSkipping";
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
            [Nn]* ) printf "\nSkipping";
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
    echo "sudo mkdir -p /var/yubico"
    echo "sudo chown root:root /var/yubico"
    echo "sudo chmod 766 /var/yubico"
    echo "sudo cp ./authorized_yubikeys /var/yubico/authorized_yubikeys"
    for i in ~/.yubico/*; do
        echo "cp $i $(echo $i | sed "s/challenge/$USER/")"
        echo "sudo mv ~/.yubico/$USER* /test/var/yubico/"
        echo "sudo chown root:root /test/var/yubico/*"
        echo "sudo chmod 600 /test/var/yubico/*"
    done
    echo "sudo chmod 700 /var/yubico"
    echo "sudo cp ./pam.d/yubikey /etc/pam.d/yubikey"
    echo "sudo cp ./pam.d/yubikey-sudo /etc/pam.d/yubikey-sudo"
    echo "sudo cp ./pam.d/yubikey-pin /etc/pam.d/yubikey-pin"
    echo -e "\nAdd 'include' statements to pam auth files to specify your security preferences."
    sleep 3s

}
InstallAptSW () {
    file="./apps/apt-apps"
    
    #while read -r line; do
    #    echo $line
    #done < $file
    #for i in array;do
    while read -r line; do
        read -p "Would you like to install $line? [Y/n]" yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) echo "sudo apt install -y $line";;
            [Nn]* ) printf "\nSkipping";
                    break;;
                * ) echo 'Please answer yes or no.';;
        esac
    done < $file
}
#check process for errors and prompt user to exit script if errors are detected.
check_exit_status() {
    if [ $? -eq 0 ]
    then
        STR=$'\nSuccess\n'
        echo "$STR"
    else
        STR='$\n[ERROR] Process Failed!\n'
        echo "$STR"

        read -p "The last command exited with an error. Exit script? (yes/no) " answer

        if [ "$answer" == "yes" ]
        then
            exit 1
        fi
    fi
}
#if Greeting; then
#    STR=$'\nProceeding\n'
#    echo "$STR"
#else
#    printf "\nGoodbye\n"; exit
#fi

#Update

#ChHostname

#SSHKeyGen

#CPbashrcvimrc

#ConfigYubikeys

InstallAptSW

#InstallFlatpaks

#InstallSnaps

#InstallOther

printf '\nGoodbye\n'
