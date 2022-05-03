#Install Firestorm Second Life Viewer
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