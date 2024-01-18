#!/bin/bash

# Function to display logs
display_logs() {
    local log_path=$1
    local display_option=$2

    clear
    echo "Displaying $display_option log:"

    if [ -e "$log_path" ]; then
        case $display_option in
            "Keyword Search")
                read -p "Enter keyword to search: " keyword
                grep -i "$keyword" "$log_path"
                ;;
            "Last 200 Lines")
                tail -n 200 "$log_path"
                ;;
            "Entire Log")
                cat "$log_path"
                ;;
        esac
    else
        echo "Log file not found: $log_path"
    fi

    read -p "Press Enter to continue..." enter_key
}

# Function for displaying filtering menu for both Debian-based and RPM-based logs
display_filter_menu() {
    local selected_log_file=$1

    while true; do
        clear
        echo "Options for $selected_log_file:"
        echo "1) Keyword Search"
        echo "2) View Last 200 Lines"
        echo "3) View Entire Log"
        echo "0) Back to Logs Submenu"

        read -p "Enter your choice: " log_option_choice

        case $log_option_choice in
            0)
                return
                ;;
            1)
                display_logs "$selected_log_file" "Keyword Search"
                ;;
            2)
                display_logs "$selected_log_file" "Last 200 Lines"
                ;;
            3)
                display_logs "$selected_log_file" "Entire Log"
                ;;
            *)
                echo "Invalid option. Please choose a valid option."
                sleep 2
                ;;
        esac
    done
}

# Function to monitor journalctl logs in real-time
monitor_journalctl_logs() {
    if command -v journalctl &> /dev/null; then
        echo "Monitoring System Logs (journalctl) in real-time. Press Ctrl+C to exit."
        sudo journalctl -f
    else
        install_command "systemd-journal"
    fi
}

# Function to handle invalid options
handle_invalid_option() {
    echo "Invalid option. Please choose a valid option."
    sleep 2
}

# Function to handle installation of a command
install_command() {
    local command_name=$1
    read -p "The '$command_name' command is not installed. Do you want to install it? (y/n): " install_choice
    if [ "$install_choice" == "y" ]; then
        sudo apt install "$command_name"
    fi
}

# Function to monitor system stats using various commands
monitor_system_stats() {
    local command_name=$1
    if command -v "$command_name" &> /dev/null; then
        "$command_name"
        return 0  # Success
    else
        install_command "$command_name"
        return 1  # Installation required
    fi
}

# Function to display menus
display_menu() {
clear
    echo ""
    echo "-------------------------------------------"
    echo "              Real Time Monitoring"
    echo "-------------------------------------------"
    echo ""
    echo "1. Monitor System Stats (top)"
    echo "2. Monitor I/O Usage (iotop)"
    echo "3. Monitor Network Traffic (nload)"
    echo "4. Monitor Network Connections (iftop)"
    echo "5. Monitor Memory Usage (free)"
    echo "6. Monitor System Activity (vmstat)"
    echo "7. Monitor System Logs (journalctl)"
    echo "8. Exit"
}

# Function for handling script exit
exit_script() {

    exit 0
}

# Main loop
while true; do
    clear
    echo ""
    echo "-------------------------------------------"
    echo "              Logs Monitoring"
    echo "-------------------------------------------"
    echo ""
    echo "1) Logs"
    echo "2) Live Monitoring"
    echo ""
    echo "0) Back to Main Menu"
echo ""
    read -p "Enter your choice: " main_choice

    case $main_choice in
        1)
            while true; do
                clear
    echo ""
    echo "-------------------------------------------"
    echo "              Logs Management"
    echo "-------------------------------------------"
    echo ""
                echo "1) Debian-based System Logs"
                echo "2) RPM-based System Logs"
                echo ""
                echo "0) Back to Main Menu"
echo ""
                read -p "Enter your choice: " logs_choice

                case $logs_choice in
                    0)
                        break
                        ;;
                    1)
                        # Debian-based System Logs
                        while true; do
                            clear
    echo ""
    echo "-------------------------------------------"
    echo "              Debian-based Management"
    echo "-------------------------------------------"
    echo ""
                            echo "1) System Logs"
                            echo "2) Authentication Logs"
                            echo "3) Package Management Logs"
                            echo "4) Boot Logs"
                            echo "5) Application Logs"
                            echo ""
                            echo "0) Back to Main Menu"
echo ""
                            read -p "Enter your choice: " debian_logs_choice

                            case $debian_logs_choice in
                                0)
                                    break
                                    ;;
                                1 | 2 | 3 | 4)
                                    log_types=("System Logs" "Authentication Logs" "Package Management Logs" "Boot Logs")
                                    log_type=${log_types[$debian_logs_choice - 1]}
                                    log_files=()

                                    case $log_type in
                                        "System Logs")
                                            log_files=("/var/log/syslog" "/var/log/kern.log")
                                            ;;
                                        "Authentication Logs")
                                            log_files=("/var/log/auth.log")
                                            ;;
                                        "Package Management Logs")
                                            log_files=("/var/log/dpkg.log" "/var/log/apt/history.log")
                                            ;;
                                        "Boot Logs")
                                            log_files=("/var/log/boot.log")
                                            ;;
                                    esac

                                    while true; do
                                        clear
                                        echo "$log_type:"
                                        for ((i = 0; i < ${#log_files[@]}; i++)); do
                                            echo "$((i + 1))) ${log_files[$i]}"
                                        done

                                        echo "0) Back to Debian Logs Submenu"
                                        read -p "Enter your choice: " log_file_choice

                                        case $log_file_choice in
                                            0)
                                                break
                                                ;;
                                            *)
                                                if [[ "$log_file_choice" =~ ^[0-9]+$ ]] && [ "$log_file_choice" -ge 1 ] && [ "$log_file_choice" -le ${#log_files[@]} ]; then
                                                    selected_log_file=${log_files[$log_file_choice - 1]}
                                                    display_filter_menu "$selected_log_file"
                                                else
                                                    handle_invalid_option
                                                fi
                                                ;;
                                        esac
                                    done
                                    ;;
                                5)
                                    # Application Logs
                                    while true; do
                                        clear
                                        echo "Application Logs:"
                                        echo ""
                                        echo "1) Nginx"
                                        echo "2) MySQL"
                                        echo "3) Apache2"
                                        echo "4) Mail"
                                        echo ""
                                        echo "0) Back to Debian Logs Submenu"
echo ""
                                        read -p "Enter your choice: " app_logs_choice

                                        case $app_logs_choice in
                                            0)
                                                break
                                                ;;
                                            1)
                                                display_logs "/var/log/nginx/access.log" "Nginx Access Log"
                                                ;;
                                            2)
                                                display_logs "/var/log/mysql/error.log" "MySQL Error Log"
                                                ;;
                                            3)
                                                display_logs "/var/log/apache2/access.log" "Apache2 Access Log"
                                                ;;
                                            4)
                                                display_logs "/var/log/mail.log" "Mail Log"
                                                ;;
                                            *)
                                                handle_invalid_option
                                                ;;
                                        esac
                                    done
                                    ;;
                                *)
                                    handle_invalid_option
                                    ;;
                            esac
                        done
                        ;;
                    2)
                        # RPM-based System Logs
                        while true; do
                            clear
    echo ""
    echo "-------------------------------------------"
    echo "              RPM-based Management"
    echo "-------------------------------------------"
    echo ""
                            echo "1) System Logs"
                            echo "2) Authentication Logs"
                            echo "3) Package Management Logs"
                            echo "4) Boot Logs"
                            echo "5) Application Logs"
                            echo "6) Additional DevOps Application Logs"
                            echo "0) Back to Top Main Menu"

                            read -p "Enter your choice: " rpm_logs_choice

                            case $rpm_logs_choice in
                                0)
                                    break
                                    ;;
                                1 | 2 | 3 | 4)
                                    log_types=("System Logs" "Authentication Logs" "Package Management Logs" "Boot Logs")
                                    log_type=${log_types[$rpm_logs_choice - 1]}
                                    log_files=()

                                    case $log_type in
                                        "System Logs")
                                            log_files=("/var/log/messages")
                                            ;;
                                        "Authentication Logs")
                                            log_files=("/var/log/secure")
                                            ;;
                                        "Package Management Logs")
                                            log_files=("/var/log/yum.log")
                                            ;;
                                        "Boot Logs")
                                            log_files=("/var/log/boot.log")
                                            ;;
                                    esac

                                    while true; do
                                        clear
                                        echo "$log_type:"
                                        for ((i = 0; i < ${#log_files[@]}; i++)); do
                                            echo "$((i + 1))) ${log_files[$i]}"
                                        done

                                        echo "0) Back to RPM Logs Submenu"
                                        read -p "Enter your choice: " log_file_choice

                                        case $log_file_choice in
                                            0)
                                                break
                                                ;;
                                            *)
                                                if [[ "$log_file_choice" =~ ^[0-9]+$ ]] && [ "$log_file_choice" -ge 1 ] && [ "$log_file_choice" -le ${#log_files[@]} ]; then
                                                    selected_log_file=${log_files[$log_file_choice - 1]}
                                                    display_filter_menu "$selected_log_file"
                                                else
                                                    handle_invalid_option
                                                fi
                                                ;;
                                        esac
                                    done
                                    ;;
                                5)
                                    # Additional DevOps Application Logs
                                    while true; do
                                        clear
                                        echo "Application Logs:"
                                        echo "1) GitLab"
                                        echo "2) Ansible"
                                        echo "3) Docker"
                                        echo "4) Kubernetes"
                                        echo ""
                                        echo "0) Back to Main Menu"
echo ""
                                        read -p "Enter your choice: " app_logs_choice

                                        case $app_logs_choice in
                                            0)
                                                break
                                                ;;
                                            1)
                                                display_logs "/var/log/gitlab/gitlab-rails/production.log" "GitLab Log"
                                                ;;
                                            2)
                                                display_logs "/var/log/ansible/ansible.log" "Ansible Log"
                                                ;;
                                            3)
                                                display_logs "/var/log/docker-compose.log" "Docker Log"
                                                ;;
                                            4)
                                                display_logs "/var/log/kubernetes/kube-apiserver.log" "Kubernetes Log"
                                                ;;
                                            *)
                                                handle_invalid_option
                                                ;;
                                        esac
                                    done
                                    ;;
                                *)
                                    handle_invalid_option
                                    ;;
                            esac
                        done
                        ;;
                    *)
                        handle_invalid_option
                        ;;
                esac
            done
            ;;
2)
    # Live Monitoring
    while true; do
        clear
    echo ""
    echo "-------------------------------------------"
    echo "              Real Time Monitoring"
    echo "-------------------------------------------"
    echo ""
    echo ""
        echo "1. Monitor System Stats (top)"
        echo "2. Monitor I/O Usage (iotop)"
        echo "3. Monitor Network Traffic (nload)"
        echo "4. Monitor Network Connections (iftop)"
        echo "5. Monitor Memory Usage (free)"
        echo "6. Monitor System Activity (vmstat)"
        echo "7. Monitor System Logs (journalctl)"
        echo "8. Exit"

        # Prompt user for choice
        read -p "Enter your choice (1-8): " choice

        case $choice in
            1 | 2 | 3 | 4 | 5)
                command_name=""
                case $choice in
                    1) command_name="top" ;;
                    2) command_name="iotop" ;;
                    3) command_name="nload" ;;
                    4) command_name="iftop" ;;
                    5) command_name="free" ;;
                esac

                if command -v "$command_name" &> /dev/null; then
                    "$command_name"
                    read -p "Press Enter to continue..."
                else
                    install_command "$command_name"
                fi
                ;;

            6)
                # Monitor System Activity (vmstat)
                monitor_system_stats "vmstat"
                read -p "Press Enter to continue..."
                ;;

            7)
                # Monitor System Logs (journalctl)
                if command -v journalctl &> /dev/null; then
                    while true; do
                        echo "Monitoring System Logs (journalctl) in real-time. Press Ctrl+C to exit."
                        sudo journalctl -f

                        echo "1. Continue Monitoring"
                        echo "0. Back to Main Menu"
                        read -p "Enter your choice (1-2): " log_continue_choice

                        case $log_continue_choice in
                            1)
                                continue
                                ;;
                            2)
                                break
                                ;;
                            *)
                                echo "Invalid choice. Please enter 1 or 2."
                                ;;
                        esac
                    done
                else
                    install_command "systemd-journal"
                fi
                ;;

            0)
                exit_script
                ;;

            *)
                # Invalid choice
                echo "Invalid choice. Please enter a number from 1 to 8."
                read -p "Press Enter to continue..."
                ;;
        esac
    done
    ;;
        0)
            exit_script
             break
            ;;
        *)
            # Invalid choice
            echo "Invalid choice. Please enter a number from 1 to 8."
            read -p "Press Enter to continue..."
            ;;
    esac
done
