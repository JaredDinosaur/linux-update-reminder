#!/bin/bash
# Check if script already exists
if [[ -e ~/updchk.sh ]]; then
    echo -e '\e[1m\e[31m'"[FAIL]" '\e(B\e[m'"This program is already installed!"
    echo -e '\e[1m\e[37m'"[STOP]" '\e(B\e[m'"To reinstall, please rename or delete ~/updchk.sh and remove its entry from ~/.bashrc."
    exit 2
fi

# Determine package manager
echo -e '\e[1m\e[34m'"[INFO]" '\e(B\e[m'"Checking package manager..."
found=0
command -v pacman >&/dev/null
if [[ $? == 0 ]]; then
    command -v yay
    if [[ $? == 0 ]]; then
        updatecmd="yay -Syu --noconfirm"
    else
        updatecmd="sudo pacman -Syu --noconfirm"
    fi
    found=1
fi
command -v apt >&/dev/null
if [[ $? == 0 ]]; then
    command -v nala >&/dev/null
    if [[ $? == 0 ]]; then
        updatecmd="sudo apt update && sudo apt upgrade -y"
    else
        updatecmd="sudo nala update && sudo nala upgrade -y"
    fi
    found=1
fi
command -v dnf >&/dev/null
if [[ $? == 0 ]]; then
    updatecmd="sudo dnf upgrade -y"
    found=1
fi
command -v zypper >&/dev/null
if [[ $? == 0 ]]; then
    updatecmd="sudo zypper refresh && sudo zypper update -y"
    found=1
fi
command -v xbps-install >&/dev/null
if [[ $? == 0 ]]; then
    updatecmd="sudo xbps-install -Syu"
    found=1
fi
command -v apk >&/dev/null
if [[ $? == 0 ]]; then
    updatecmd="sudo apk update && sudo apk upgrade"
    found=1
fi
if [[ $found == 0 ]]; then
    echo -e '\e[1m\e[31m'"[FAIL]" '\e(B\e[m'"Your distribution is not supported!"
    echo -e '\e[1m\e[37m'"[STOP]" '\e(B\e[m'"Check distro support in README.md."
    exit 3
fi

# Check for flatpak and snap
echo -e '\e[1m\e[34m'"[INFO]" '\e(B\e[m'"Checking for Flatpak and Snap..."
fpupd=""
snapupd=""
command -v flatpak >&/dev/null
if [[ $? == 0 ]]; then
    echo -e '\e[1m\e[32m'"[ OK ]" '\e(B\e[m'"Flatpak is installed."
    fpupd="flatpak update -y"
fi
command -v snap >&/dev/null
if [[ $? == 0 ]]; then
    echo -e '\e[1m\e[32m'"[ OK ]" '\e(B\e[m'"Snap is installed."
    snapupd="sudo snap refresh"
fi

# Ask user for time between reminders
echo
read -p "After how many days would you like to be reminded to update? (7 recommended for weekly reminders) " delay
while ! [[ $delay =~ ^[0-9]+$ ]]; do
    echo "That is not a valid number!"
    read -p "After how many days would you like to be reminded to update? " delay
done

# Create reminder script and add it to ~/.bashrc
echo -e '\e[1m\e[34m'"[INFO]" '\e(B\e[m'"Creating reminder script..."
cat > ~/updchk.sh << "EOF"
#!/bin/bash
if [[ -s ~/lastupdate.log ]]; then
    lastupdate=`cat ~/lastupdate.log`
else
    lastupdate=0
fi
curdate=`date +%Y%m%d`
EOF
echo "sinceupd=\$(( curdate - lastupdate ))" >> ~/updchk.sh
echo "if [[ \$sinceupd -gt $delay ]]; then" >> ~/updchk.sh
echo "    loop=1" >> ~/updchk.sh
echo "    while [[ $loop == 1 ]]; do" >> ~/updchk.sh
cat >> ~/updchk.sh << "EOF"
        clear
        echo -e '\e[3m'"You've not updated your system in a while!"'\e(B\e[m'
        echo -e '\e[3m'"What would you like to do?"'\e(B\e[m'
        echo
        echo -e '\e[36m'"[1]" '\e(B\e[m'"Update now"
        echo -e '\e[36m'"[2]" '\e(B\e[m'"I'll do it later"
EOF
echo "        echo -e '\e[36m'\"[3]\" '\e(B\e[m'\"Snooze reminders for $delay days\"" >> ~/updchk.sh
echo "        read -n 1 choice" >> ~/updchk.sh
echo "        case $choice in" >> ~/updchk.sh
echo "            1)" >> ~/updchk.sh
echo "                clear" >> ~/updchk.sh
echo "                $updatecmd" >> ~/updchk.sh
echo "                $fpupd" >> ~/updchk.sh
echo "                $snapupd" >> ~/updchk.sh
echo "                date +%Y%m%d > ~/lastupdate.log" >> ~/updchk.sh
cat >> ~/updchk.sh << "EOF"
                echo
                loop=0
                ;;
            2)
                clear
                loop=0
                ;;
            3)
                date +%Y%m%d > ~/lastupdate.log
                clear
                loop=0
                ;;
            *)
                ;;
        esac
    done
EOF
chmod +x ~/updchk.sh
echo -e '\e[1m\e[34m'"[INFO]" '\e(B\e[m'"Adding reminder script to ~/.bashrc..."
echo "~/updchk.sh" >> ~/.bashrc

echo -e '\e[1m\e[32m'"[ OK ]" '\e(B\e[m'"Reminder script installed."
echo -e '\e[1m\e[35m'"[DONE]" '\e(B\e[m'"Installation complete. You will be reminded to update when you next open the terminal."
