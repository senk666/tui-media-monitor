#!/bin/bash

if ! command -v playerctl &> /dev/null; then
    echo "Error: playerctl is not installed."
    exit 1
fi

clear
tput civvis

loading_icons=( "/" "-" "\\" "|" )
animation_step=0

reset_terminal() {
    stty echo
    tput cnorm
    clear
    echo "Player monitor successfully stopped."
    exit 0
}

trap reset_terminal SIGINT SIGTERM EXIT
trap 'clear' SIGWINCH
stty -echo

while true; do
    # [EN] Read button presses without blocking the screen | [RU] Считывание нажатий клавиш без задержки экрана
    if read -r -t 0.02 -n 1 key; then
        case "$key" in
            "")  playerctl play-pause 2>/dev/null ;;
            " ") playerctl play-pause 2>/dev/null ;; 
            ".") playerctl next 2>/dev/null ;;
            ",") playerctl previous 2>/dev/null ;;
            "+") amixer set Master 5%+ &>/dev/null ;; 
            "=") amixer set Master 5%+ &>/dev/null ;; 
            "-") amixer set Master 5%- &>/dev/null ;; 
        esac
    fi

    tput cup 0 0
    playback_status=$(playerctl status 2>/dev/null)
    
    # [EN] Rendering the interface lines in the terminal | [RU] Отрисовка строк интерфейса в терминале
    echo -e "\e[1;37m┌────────────────────────────────────────┐\e[K\e[0m"
    echo -e "\e[1;37m│               NOW PLAYING              │\e[K\e[0m"
    echo -e "\e[1;37m└────────────────────────────────────────┘\e[K\e[0m"

    if [ "$playback_status" = "Playing" ]; then
        current_artist=$(playerctl metadata xesam:artist 2>/dev/null | cut -c1-28)
        current_track=$(playerctl metadata xesam:title 2>/dev/null | cut -c1-28)
        music_source=$(playerctl metadata scrambled:player_name 2>/dev/null || playerctl -l 2>/dev/null | head -n 1)
        
        [ -z "$current_track" ] && current_track="Unknown Track"
        [ -z "$current_artist" ] && current_artist="Unknown Artist"
        [ -z "$music_source" ] && music_source="Unknown Process"

        echo -e " \e[1;37mArtist:\e[0m \e[1;36m$current_artist\e[K\e[0m"
        echo -e " \e[1;37mTrack:\e[0m  \e[1;36m$current_track\e[K\e[0m"
        echo -e " \e[1;37mSource:\e[0m \e[1;35m$music_source\e[K\e[0m"
        echo -e " \e[1;37mStatus:\e[0m \e[1;32mPlaying\e[0m  \e[1;37m[ ${loading_icons[$animation_step]} ]\e[K\e[0m"
        animation_step=$(( (animation_step + 1) % 4 ))
    elif [ "$playback_status" = "Paused" ]; then
        current_artist=$(playerctl metadata xesam:artist 2>/dev/null | cut -c1-28)
        current_track=$(playerctl metadata xesam:title 2>/dev/null | cut -c1-28)
        music_source=$(playerctl -l 2>/dev/null | head -n 1)
        
        [ -z "$current_track" ] && current_track="---"
        [ -z "$current_artist" ] && current_artist="---"
        [ -z "$music_source" ] && music_source="---"

        echo -e " \e[1;37mArtist:\e[0m \e[1;30m$current_artist\e[K\e[0m"
        echo -e " \e[1;37mTrack:\e[0m  \e[1;30m$current_track\e[K\e[0m"
        echo -e " \e[1;37mSource:\e[0m \e[1;30m$music_source\e[K\e[0m"
        echo -e " \e[1;37mStatus:\e[0m \e[1;33mPaused\e[0m   \e[1;37m[ II ]\e[K\e[0m"
    else
        echo -e " \e[1;31mNo active playback detected\e[K\e[0m"
        echo -e " Start music in your player/browser...\e[K"
        echo -e "\e[K"
        echo -e "\e[K"
    fi

    system_volume=$(amixer get Master | grep -o -m 1 '[0-9]*%' | tr -d '%')
    [ -z "$system_volume" ] && system_volume="--"

    echo -e "\e[1;37m──────────────────────────────────────────\e[K\e[0m"
    echo -e " \e[1;37mVolume:\e[0m \e[1;37m$system_volume%\e[K\e[0m"
    echo -e "\e[1;37m──────────────────────────────────────────\e[K\e[0m"
    echo -e " \e[1;37m[Space] Pause | [,] Previous | [.] Next\e[K\e[0m"
    echo -e " \e[1;37m[-] Vol Down  | [+] Vol Up\e[K\e[0m"
    echo -e " \e[1;37m[ Press Ctrl+C to Exit ]\e[K\e[0m"
    
    tput ed

    # 3. [EN] Artificial delay to lower CPU usage down to ~0% | [RU] Искусственная пауза для разгрузки процессора (снижает CPU до ~0%)
    sleep 0.15
done
