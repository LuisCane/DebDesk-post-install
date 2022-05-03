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