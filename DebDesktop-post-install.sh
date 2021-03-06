#!/bin/bash

#Common Setup after installing Debian Based Desktop OS.
#Part 1 - Update & Upgrade software and install vim
#   apt
#   firmware
#   flatpak
#   install vim
#   install sudo
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
#       vlc
#       putty
#       variety
#       steam
#       lutris
#       cool-retro-term
#       tilix
#       virtviewer
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
    printf '\nWelcome to my post installation script for Pop!_OS and other Debian based distros.'
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
#Install VIM
InstallVIM () {
    printf '\nWould you like to install VIM? [y/n]'
    read -r yn
    case $yn in
        [Yy]* ) printf '\nInstalling VIM\n'
                apt install -y vim
                check_exit_status;
                return 0;;
        [Nn]* ) printf '\nSkipping VIM'
                return 0;;
            * ) printf '\nPlease enter yes or no.\n'
                ;;
    esac
}
#Install Spice tools for VMs
InstallSpiceVDAgent () {
    printf '\nIf this is a QEMU/Spice Virtual Machine, installing the Spice Tools is recommended.\nWould you like to install Spice-vdagent? [y/n]'
    read -r yn
    case $yn in
        [Yy]* ) printf '\nInstalling spice-vdagent\n'
                apt install -y spice-vdagent
                check_exit_status;
                return 0;;
        [Nn]* ) printf '\nSkipping Spice-VDagent\n'
                return 0;;
            * ) printf '\nPlease enter yes or no.\n'
                ;;
    esac
}
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
#Change System Hostname
ChHostname () {
    while true; do
        printf "\nYour System Hostname is $HOSTNAME \n"
        read -p $'Would you like to change the hostname? [y/N]' yn
        yn=${yn:-N}
        case $yn in
            [Yy]* ) read -p "Please enter a new Hostname: " NEWHOSTNAME;
                    hostnamectl set-hostname $NEWHOSTNAME
                    return 0;;
            [Nn]* ) echo
                    printf '\nHostname %s will not be changed.\n' $HOSTNAME ;
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
            [Nn]* ) printf '\nSSH Key Not generated\n';
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
}
#Copy bashrc and vimrc to home folder
CPbashrc () {
    while true; do 
        read -p 'Would you like to copy the bashrc file included with this script to your home folder? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
            [Yy]* ) cp ./home/user/bashrc ~/.bashrc
                    break;;
            [Nn]* ) printf '\nOK\n'
                    break;;
                * ) echo 'Please answer yes or no.';;
        esac
    done
}
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
    apt install -y libpam-yubico;
    check_exit_status
    printf '\napt install -y libpam-u2f\n'
    apt install -y libpam-u2f;
    check_exit_status
    printf '\napt install -y yubikey-manager\n'
    apt install -y yubikey-manager;
    check_exit_status
    printf '\napt install -y yubikey-personalization\n'
    apt install -y yubikey-personalization;
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
InstallSW () {
    while true; do
    read -p $'Would you like to install apt packages? [Y/n]' yn
    yn=${yn:-Y}
    case $yn in
        [Yy]* ) InstallAptSW
                break
                ;;
        [Nn]* ) printf "\nSkipping apt packages\n";
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done

    while true; do
        read -p $'Would you like to install Flatpaks? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
        [Yy]* ) apt install flatpak
                InstallFlatpaks
                break
                ;;
        [Nn]* ) printf "\nSkipping Flatpaks\n";
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done

    while true; do
        read -p $'Would you like to install snap packages? [Y/n]' yn
        yn=${yn:-Y}
        case $yn in
        [Yy]* ) echo 'apt install snapd\n'
                apt install snapd
                InstallSnaps
                break
                ;;
        [Nn]* ) printf "\nSkipping Snaps\n";
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done

    while true; do
        printf $'Would you like to install Firestorm Viewer? [Y/n]'
        read -r yn
        yn=${yn:-Y}
        case $yn in
        [Yy]* ) echo 'Installing Firestorm'
                read -rsn1 -p "Please ensure that the download link in ./apps/firestorm is the latest version. Press any key to continue."
                InstallFirestorm
                break
                ;;
        [Nn]* ) printf "\nSkipping Firestorm\n";
                    break;;
            * ) echo 'Please answer yes or no.';;
        esac
    done
}
InstallAptSW() {
    printf 'Installing Apt Packages\n'
    sleep 1s
  file='./apps/apt-apps'

  while read -r line <&3; do
    printf 'Would you like to install %s [Y/n]? ' "$line"

    read -r yn
    yn=${yn:-Y}
    case $yn in
      [Yy]*) echo apt install -y "$line" 
            apt install -y "$line"
            check_exit_status
            ;;
      [Nn]*) printf '\nSkipping %s\n' "$line";;
      *) break ;;
    esac
  done 3< "$file"
}
InstallFlatpaks () {
    printf 'Installing Flatpaks'
  file='./apps/flatpaks'

  while read -r line <&3; do
    printf 'Would you like to install %s [Y/n]? ' "$line"
    read -r yn
    yn=${yn:-Y}
    case $yn in
      [Yy]*) echo flatpak install -y "$line"
            flatpak install -y "$line"
             check_exit_status
             ;;
      [Nn]*) printf '\nSkipping %s\n' "$line";;
      *) break ;;
    esac
  done 3< "$file"
}
InstallSnaps () {
    printf 'Installing Snaps'
  file='./apps/snaps'

  while read -r line <&3; do
    printf 'Would you like to install %s [Y/n]? ' "$line"
    read -r yn
    yn=${yn:-Y}
    case $yn in
      [Yy]*) echo snap install -y "$line"
            snap install "$line"
             check_exit_status
             ;;
      [Nn]*) printf '\nSkipping %s\n' "$line";;
      *) break ;;
    esac
  done 3< "$file"
}
InstallFirestorm () {
    file='./apps/firestorm'
    read -r url < "$file"

    printf 'Downloading Firestorm\n'
    wget "$url"
    printf '\nextracting\n'
    tar -xvf Phoenix_Firestorm-Release_x86_64*.tar.xz
    printf '\nChanging the install script to be executable\m'
    chmod +x Phoenix_Firestorm*/install.sh
    printf 'installing Firestorm'
    ./Phoenix_Firestorm*/install.sh
    printf '\ncleanup\n'
    rm -r ./Phoenix_Firestorm*
     
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

if Greeting; then
    STR=$'\nProceeding\n'
    echo "$STR"
else
    printf "\nGoodbye\n"; exit
fi

Update

InstallSudo

InstallVIM

InstallSpiceVDAgent

InstallRefind

ChHostname

SSHKeyGen

CPbashrc

CPvimrc

ConfigYubikeys

InstallSW

printf '\nGoodbye\n'
