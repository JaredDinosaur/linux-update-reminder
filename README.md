# linux-update-reminder
A BASH script for several Linux distributions which reminds the user to update their system after a set amount of time.

The script will run every time you open the terminal, and has an option to snooze reminders.

To install this script, run:
```
chmod +x install.sh
./install.sh
```

The installer allows you to set the number of days between reminders, which is also the number of days to snooze for.

The number of days is date-based and not time based. 

For example, if you snooze reminders for 1 day at 23:00, you will be reminded at the start of the next day (in 1 hour).

## Distribution support
Currently, only the following distribution families are supported:
- Arch Linux, including:
    * Archcraft
    * Artix
    * CachyOS
    * EndeavourOS
    * Garuda Linux
    * Manjaro
- Debian, including:
    * ElementaryOS
    * Kali Linux
    * KDE Neon
    * Linux Mint and LMDE
    * MX Linux
    * Pop!_OS
    * TUXEDO OS
    * Ubuntu and flavours (e.g. Kubuntu)
    * VanillaOS
    * Zorin OS
- Red Hat, including:
    * Alma Linux
    * Bazzite
    * Fedora
    * Nobara
    * Rocky Linux
- OpenSUSE
- Solus
- Void Linux
- Alpine Linux
