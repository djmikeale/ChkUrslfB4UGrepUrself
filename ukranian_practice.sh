#!/bin/bash

ukrainian_alphabet=(A Б В Г Ґ Д Е Є Ж З И i Ї Й К Л М Н О П Р С Т У Ф Х Ц Ч Ш Щ Ю)
english_alphabet=(a b v h g d e ye zh z i i yi y k l m n o p r s t u f kh ts ch sh shch yu)

clear

echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo "┃           ____                             ┃"
echo "┃   _____  / __/  __//______ __  _______     ┃"
echo "┃   \__  \| __ \_/ __ \   __|  |/ /\__  \    ┃"
echo "┃    / __ \ \_\ \  ___/|  | |    <  / __ \   ┃"
echo "┃   (_____|\____/\___| |__| |__|__|(_____|   ┃"
echo "┃                                            ┃"
echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"
echo "┃            Learn some cyrillic!            ┃"
echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
echo ""

echo "1: Ukrainian to English"
echo "2: English to Ukrainian"

while true; do
    read -s -n 1 -p "Please enter 1 or 2 (or 'q' to quit): " translation_direction

    case "$translation_direction" in
        1)
            from_lang=("${ukrainian_alphabet[@]}")
            to_lang=("${english_alphabet[@]}")
            translation_direction_text="Ukrainian to English"
            break
            ;;
        2)
            from_lang=("${english_alphabet[@]}")
            to_lang=("${ukrainian_alphabet[@]}")
            translation_direction_text="English to Ukrainian"
            break
            ;;
        q)
            echo "Quitting..."
            exit
            ;;
        *)
            echo "Invalid input. Please try again."
            ;;
    esac
done

array_length=${#from_lang[@]}

while true; do
    clear
    echo "$(tput bold)$translation_direction_text$(tput sgr0) | Press Enter to continue or '$(tput setaf 1)q$(tput sgr0)' to quit: "
    random_index=$((RANDOM % array_length))
    from=${from_lang[$random_index]}
    to=${to_lang[$random_index]}

    echo -ne "$from --> ?\r"
    read -s -n 1 user_input
    echo "$from --> $to"

    # Check if the user wants to quit
    if [[ "$user_input" == "q" ]]; then
        echo "Quitting..."
        break  # Exit the loop
        clear
    fi

    sleep 1
done
