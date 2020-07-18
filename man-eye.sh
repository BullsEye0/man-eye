#!/bin/bash

# ▀█████████▄     ▄████████         Websites: Bullseye0.com | HackingPassion.com
#   ███    ███   ███    ███         Author: Jolanda de Koff | Bulls Eye
#   ███    ███   ███    █▀          GitHub: https://github.com/BullsEye0
#  ▄███▄▄▄██▀   ▄███▄▄▄             linkedin: https://www.linkedin.com/in/jolandadekoff
# ▀▀███▀▀▀██▄  ▀▀███▀▀▀             Facebook Group: https://www.facebook.com/groups/hack.passion/
#   ███    ██▄   ███    █▄          Facebook: facebook.com/jolandadekoff
#   ███    ███   ███    ███         YouTube: https://www.youtube.com/channel/UCeHez_7Bkwh7ve4pW2EQJrw
# ▄█████████▀    ██████████         LBRY: https://lbry.tv/$/invite/@bullseye0:f

# Learn Linux Through Man Pages
# How cool would it be to learn Linux through the man pages
# To make it even more fun, I made this script with various options and with a cool retro terminal.

# There are some packages to install to use this tool:
# sudo apt install suckless-tools
# sudo apt install groff
# sudo apt install cool-retro-term
# sudo apt install zathura
# sudo apt install fzf

# Or in one line: sudo apt install suckless-tools zathura groff cool-retro-term fzf

declare options=("Random-Man-Page
Search-Man-Pages
Man-On-Steroids
Man-PDF
Quit")

choice=$(echo -e "${options[0]}" | dmenu -i -l 5 -p "Hi there, Shall we play a game 😃 ")

case "$choice" in

    Random-Man-Page)
        find /usr/share/man/man1 -type f | shuf | awk -F '/' '/1/ {print $6}' | sed 's/.gz//g' |
        head -1 | xargs cool-retro-term -e "man"
    ;;
    Search-Man-Pages)
        man -k . | awk "{ print $1 }" | dmenu -i -l 16 -p "Search Manpages" | xargs cool-retro-term -e "man"
    ;;
    Man-On-Steroids)
    # https://hiphish.github.io/blog/2020/05/31/macho-man-command-on-steroids/
        export FZF_DEFAULT_OPTS='
        --height=35%
        --layout=reverse
        --prompt="Manual: "
        --preview="echo {1} | sed -E \"s/^\((.+)\)/\1/\" | xargs -I{S} man -Pcat {S} {2} 2>/dev/null"'

        while getopts ":s:" opt; do
            case $opt in
                s ) SECTION=$OPTARG; shift; shift
                ;;
                \?) echo "Invalid option: -$OPTARG" >&2; exit 1
                ;;
                : ) echo "Option -$OPTARG Requires an argument" >&2; exit 1
                ;;
            esac
        done

        manual=$(apropos -s ${SECTION:-''} ${@:-.} | \
            grep -v -E '^.+ \(0\)' |\
            awk '{print $2 "    " $1}' | \
            sort | \
            fzf  | \
            sed -E 's/^\((.+)\)/\1/')
            cool-retro-term -e "man" $manual
    ;;
    Man-PDF)
        export FZF_DEFAULT_OPTS='
        --height=35%
        --layout=reverse
        --prompt="Manual: "
        --preview="echo {1} | sed -E \"s/^\((.+)\)/\1/\" | xargs -I{S} man -Pcat {S} {2} 2>/dev/null"'

        while getopts ":s:" opt; do
            case $opt in
                s ) SECTION=$OPTARG; shift; shift
                ;;
                \?) echo "Invalid option: -$OPTARG" >&2; exit 1
                ;;
                : ) echo "Option -$OPTARG Requires an argument" >&2; exit 1
                ;;
            esac
        done

        manual=$(apropos -s ${SECTION:-''} ${@:-.} | \
            grep -v -E '^.+ \(0\)' |\
            awk '{print $2 "    " $1}' | \
            sort | \
            fzf  | \
            sed -E 's/^\((.+)\)/\1/')

        if [ -z "$MANUAL" ]; then
            man -T${FORMAT:-pdf} $manual | ${READER:-zathura -}
        fi
    ;;
    Quit)
        echo "[•] Exiting Platform... like to See Ya, Hacking 😃" && exit 1
esac

