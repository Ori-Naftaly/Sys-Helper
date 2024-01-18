#!/bin/bash

prompt() {
    read -p "$1" response
    echo "$response"
}

renice_process() {
    pid=$1
    current_nice=$(ps -o nice= -p $pid)

    if [ -z "$current_nice" ]; then
        echo "Error: Invalid PID or no permission to renice."
    else
        echo "Current Nice value of process $pid: $current_nice"
        new_nice=$(prompt "Enter new Nice value: ")
        renice $new_nice -p $pid
        echo "Process $pid reniced to $new_nice"
    fi
}

while true; do
    clear
    echo ""
    echo "-------------------------------------------"
    echo "              Process Management"
    echo "-------------------------------------------"
    echo ""
    echo "1) Search Process"
    echo "2) List Running Processes"
    echo "3) Find Process Path"
    echo "4) Change Niceness"
    echo "5) Live Top Feel"
    echo "6) Show Jobs"
    echo ""
    echo "0) --Back to Main Menu--"
    echo ""

    choice=$(prompt "Enter your choice (1-7): ")

    case $choice in
        1)

            echo "Search Process:"
            echo "1. Search by Name"
            echo "2. Search by PID"
            sub_choice=$(prompt "Enter sub-menu choice (a-b): ")

            case $sub_choice in
                1)
                    process_name=$(prompt "Enter process name to search: ")
                    ps aux | grep "$process_name"
                    prompt "Click Enter to continue..."
                    ;;
                2)
                    pid=$(prompt "Enter PID to search: ")
                    ps -p $pid
                    prompt "Click Enter to continue..."
                    ;;
                *) echo "Invalid choice"; prompt "Click Enter to continue...";;
            esac
            ;;
        2)

            echo "List Running Processes:"
            ps aux
            prompt "Click Enter to continue..."
            ;;
        3)

            echo "Find Process Path:"
            process_id=$(prompt "Enter Process ID to find its path: ")
            process_path=$(readlink -f /proc/$process_id/exe)

            if [ -e "$process_path" ]; then
                echo "Path of process $process_id: $process_path"
            else
                echo "Error: Process not found or no permission to access its path."
            fi

            prompt "Click Enter to continue..."
            ;;
        4)
            renice_choice=$(prompt "Do you want to renice? (y/n): ")
            if [ "$renice_choice" == "y" ]; then
                pid=$(prompt "Enter PID to renice: ")
                renice_process $pid
            fi

            prompt "Click Enter to continue..."
            ;;
        5)
            clear
            echo "Live Top Feel:"
            top
            prompt "Click Enter to continue..."
            ;;
        6)
            echo "Show Jobs:"
            jobs
            prompt "Click Enter to continue..."
            ;;
        0)

            break
            ;;
        *)
            echo "Error: Invalid choice. Please enter a number between 1 and 7."
            prompt "Click Enter to continue..."
            ;;
    esac
done

