#!/bin/bash

# Function for repeated input prompt and validation
get_input() {
    local prompt="$1"
    local variable="$2"

    read -rp "$prompt" "$variable"

    # Validate if the input is not empty
    if [ -z "${!variable}" ]; then
        echo "Invalid input. $prompt"
        get_input "$prompt" "$variable"
    fi
}

# Function to execute a command and display results
execute_command() {
    local command="$1"

    echo "Executing: $command"

    # Capture the command output
    eval "$command"
    local exit_status=$?

    # Check the command exit status
    if [ $exit_status -ne 0 ]; then
        echo "Command execution failed with exit status $exit_status."
    fi
}

# Function to confirm user action
are_you_sure() {
    local action="$1"

    read -rp "Are you sure you want to make $action changes? (y/n): " confirm_choice

    case $confirm_choice in
    [Yy])
        return 0 ;; # User confirmed
    [Nn])
        return 1 ;; # User canceled
    *)
        echo "Invalid choice. Please enter 'y' or 'n'."
        are_you_sure "$action" ;; # Repeat the question
    esac
}

# Function to confirm and apply change
confirm_and_apply_change() {
    local change_description="$1"
    local command="$2"
    local status_command="$3"

    if execute_command "$command"; then
        echo "$change_description changes applied."
        execute_command "echo -e '\nDisplaying current $change_description status:'"
        execute_command "$status_command"
        read -rp "Do you want to keep the changes? (y/n): " keep_changes_choice
        if [ "$keep_changes_choice" == "n" ]; then
            # Implement the command to revert $change_description changes
            echo "Implement the command to revert $change_description changes"
            echo "$change_description changes reverted. Press Enter to continue..."
        else
            echo "Changes kept. Press Enter to continue..."
        fi
    else
        echo "$change_description changes failed. Press Enter to continue..."
    fi
}

# Function to check firewall status and open ports
check_firewall() {
    echo " Firewall Information:"

    # Check if firewalld is present
    if command -v firewalld &>/dev/null; then
        execute_command "sudo systemctl is-active firewalld"
    else
        echo "firewalld is not installed."
    fi

    # Check if ufw is present
    if command -v ufw &>/dev/null; then
        execute_command "sudo ufw status"
    else
        echo "ufw is not installed."
    fi

    # Display open ports
    execute_command "sudo ss -tuln"
}

while true; do
    clear
    echo ""
    echo "-------------------------------------------"
    echo "              Network Management"
    echo "-------------------------------------------"
    echo ""
        echo "1. Network/Firewall Information"
    echo "2. Network Troubleshooting"

    echo "3. Change Network Settings"
    echo ""
    echo "0. --Back to Main Menu--"
echo ""
    get_input "Enter your choice (0-3): " "choice"

    case $choice in
    1)
        clear
    echo ""
    echo "-------------------------------------------"
    echo "             Network Troubleshoot"
    echo "-------------------------------------------"
    echo ""
        echo "1. Ping"
        echo "2. Traceroute"
        echo "3. Trace Route (press q to quit)"
        echo "5. Display Network Activity"
        echo "6. DNS Query"
        echo "7. Show Arp"
        echo "8. Reset DHCP"
        echo ""
        echo "0. --Back to Networking Menu--"
echo ""
        get_input "Enter your choice (0-8): " "troubleshoot_choice"

        case $troubleshoot_choice in
        1) get_input "Enter destination for ping: " "ping_destination"
            execute_command "ping -c 4 $ping_destination"
            read -rp "Press Enter to continue..."
            ;;
        2) get_input "Enter destination for traceroute: " "traceroute_destination"
            execute_command "traceroute $traceroute_destination"
            read -rp "Press Enter to continue..."
            ;;
        3) get_input "Enter destination for mtr: " "mtr_destination"
            execute_command "mtr $mtr_destination"
            read -rp "Press Enter to continue..."
            ;;
        5)
            execute_command "sudo tcpdump -n -i any -vvv -q &"
            read -rp "Press Enter to stop capturing and continue..."
            pkill -f "tcpdump"
            ;;
        6) get_input "Enter domain for nslookup: " "nslookup_domain"
            execute_command "nslookup $nslookup_domain"
            read -rp "Press Enter to continue..."
            ;;
        7) execute_command "arp -a"
            read -rp "Press Enter to continue..."
            ;;
        8)
            echo ".___DHCP Operation___."
            PS3="Choose DHCP operation: "
            options=("Reset DHCP (Release and Pull)" "Release" "Pull" "Back to Troubleshooting Menu")
            select dhcp_operation in "${options[@]}"; do
                case $REPLY in
                1) execute_command "sudo dhclient -r && sudo dhclient"
                    break ;;
                2) execute_command "sudo dhclient -r"
                    break ;;
                3) execute_command "sudo dhclient"
                    break ;;
                4) break ;;
                *) echo "Invalid option. Try again." ;;
                esac
            done
            ;;
        0) ;;
        *) echo "Invalid choice. Press Enter to continue..."; read -rp ""; ;;
        esac
        ;;
    2)
        clear

               echo ""
    echo "-------------------------------------------"
    echo "              Firewall Management"
    echo "-------------------------------------------"
    echo ""

        # Display open ports first
        check_firewall

        # Continue with other network information
        echo -e "\nNetwork Information:"
        echo -e "\nIP Address (with NIC names):"
        ip -br addr show | awk '{print $1, $3}'

        echo -e "\nDefault Gateway:"
        ip route | awk '/default/ {print $3}'

        echo -e "\nDNS Servers:"
        grep -w "nameserver" /etc/resolv.conf | awk '{print $2}'

        echo -e "\nMAC Address (Active NIC):"
        ip link show | awk '/state UP/{getline; print $2}'

        read -rp "Press Enter to continue..."
        ;;
    3)
        clear
    echo ""
    echo "-------------------------------------------"
    echo "              Network Settings"
    echo "-------------------------------------------"
    echo ""
    echo ""
        echo "1. Change Static IP"
        echo "2. Change Gateway"
        echo "3. Change DNS"
        echo ""
        echo "0. Back to Networking Menu"
echo ""
        get_input "Enter your choice (0-4): " "change_net_choice"

        case $change_net_choice in
1)
    # Find available NICs and prompt the user to choose
    available_nics=($(ip link show | grep 'state UP' | awk -F ': ' '{print $2}'))
    if [ "${#available_nics[@]}" -eq 0 ]; then
        echo "No active NICs found. Cannot change static IP."
    else
        echo "Available NICs:"
        for ((i = 0; i < ${#available_nics[@]}; i++)); do
            echo "$((i + 1)). ${available_nics[i]}"
        done

        get_input "Choose a NIC (1-${#available_nics[@]}): " "nic_choice"

        if [[ "$nic_choice" =~ ^[1-9]$ && "$nic_choice" -le "${#available_nics[@]}" ]]; then
            selected_nic="${available_nics[nic_choice - 1]}"
            if are_you_sure "Static IP for $selected_nic"; then
                get_input "Enter new IP address (IPv4, 24 subnet mask): " "new_ip"

                # Ensure IPv4 and use a 24 subnet mask
                new_ip="${new_ip}/24"

                # Remove existing IPv4 addresses for the selected NIC
                execute_command "sudo ip -4 addr flush dev $selected_nic"

                # Add the new IPv4 address for the selected NIC
                if execute_command "sudo ip addr add $new_ip dev $selected_nic"; then
                    # Display current IP settings without showing the command
                    execute_command "echo -e '\nDisplaying current IP address for $selected_nic:'"
                    execute_command "ip addr show $selected_nic | grep 'inet ' | awk '{print \$2}'"

                    echo -e "\033[1mIP address changes applied. Press Enter to continue...\033[0m"; read -rp ""
                else
                    echo -e "\033[1mFailed to change IP address. Press Enter to continue...\033[0m"; read -rp ""
                fi
            else
                echo -e "\033[1mIP address changes canceled. Press Enter to continue...\033[0m"; read -rp ""
            fi
        else
            echo "Invalid NIC choice. Press Enter to continue..."; read -rp ""
        fi
    fi
    ;;

2)

    # Find available NICs and prompt the user to choose
    available_nics=($(ip link show | grep 'state UP' | awk -F ': ' '{print $2}'))
    if [ "${#available_nics[@]}" -eq 0 ]; then
        echo "No active NICs found. Cannot change gateway."
    else
        echo "Available NICs:"
        for ((i = 0; i < ${#available_nics[@]}; i++)); do
            echo "$((i + 1)). ${available_nics[i]}"
        done

        get_input "Choose a NIC (1-${#available_nics[@]}): " "nic_choice"

        if [[ "$nic_choice" =~ ^[1-9]$ && "$nic_choice" -le "${#available_nics[@]}" ]]; then
            selected_nic="${available_nics[nic_choice - 1]}"
            if are_you_sure "Gateway for $selected_nic"; then
                get_input "Enter new gateway: " "new_gateway"

                # Remove existing default gateway for the selected NIC
                execute_command "sudo ip route delete default dev $selected_nic"

                # Add the new gateway for the selected NIC
                if execute_command "sudo ip route add default via $new_gateway dev $selected_nic"; then
                    # Display current Gateway settings without showing the command
                    execute_command "echo -e '\nDisplaying current Gateway status:'"
                    execute_command "ip route | grep default | awk '{print \$3}'"

                    echo -e "\033[1mGateway changes applied. Press Enter to continue...\033[0m"; read -rp ""
                else
                    echo -e "\033[1mFailed to change gateway. Press Enter to continue...\033[0m"; read -rp ""
                fi
            else
                echo -e "\033[1mGateway changes canceled. Press Enter to continue...\033[0m"; read -rp ""
            fi
        else
            echo "Invalid NIC choice. Press Enter to continue..."; read -rp ""
        fi
    fi
    ;;
3)

 
    if are_you_sure "DNS"; then
        # Find available NICs and prompt the user to choose
        available_nics=($(ifconfig -s | awk 'NR>1 {print $1}'))
        if [ "${#available_nics[@]}" -eq 0 ]; then
            echo "No active NICs found. Cannot change DNS."
        else
            echo "Available NICs:"
            for ((i = 0; i < ${#available_nics[@]}; i++)); do
                echo "$((i + 1)). ${available_nics[i]}"
            done

            get_input "Choose a NIC (1-${#available_nics[@]}): " "nic_choice"

            if [[ "$nic_choice" =~ ^[1-9]$ && "$nic_choice" -le "${#available_nics[@]}" ]]; then
                selected_nic="${available_nics[nic_choice - 1]}"

                # Check if DNS is already set for the selected NIC
                current_dns=$(cat /etc/resolv.conf | grep -w "$selected_nic" | awk '{print $2}')
                if [ -n "$current_dns" ]; then
                    echo -e "Current DNS IP for $selected_nic: $current_dns"

                    # Confirm deletion of the existing DNS IP
                    read -rp "Do you want to delete the existing DNS IP? (y/n): " delete_dns_choice
                    if [ "$delete_dns_choice" == "y" ]; then
                        # Delete the existing DNS IP
                        sudo sed -i "/$selected_nic/d" /etc/resolv.conf
                        echo "Existing DNS IP deleted."

                        # Prompt user for the new DNS IP
                        get_input "Enter new DNS: " "new_dns"

                        # Implement the command to change DNS for the selected NIC using ifconfig
                        sudo ifconfig "$selected_nic" down
                        sudo ifconfig "$selected_nic" "$new_dns" netmask 255.255.255.0 up

                        # Display current DNS settings without showing the command
                        echo -e "\n\033[1mUpdated DNS IP ($selected_nic): $new_dns\033[0m"
                        echo -e "\033[1mDNS changes applied. Press Enter to continue...\033[0m"; read -rp ""
                    else
                        echo -e "\033[1mDNS changes canceled. Press Enter to continue...\033[0m"; read -rp ""
                    fi
                else
                    echo "No existing DNS IP found for $selected_nic."
                    get_input "Enter new DNS: " "new_dns"

                    # Implement the command to change DNS for the selected NIC using ifconfig
                    sudo ifconfig "$selected_nic" down
                    sudo ifconfig "$selected_nic" "$new_dns" netmask 255.255.255.0 up

                    # Display current DNS settings without showing the command
                    echo -e "\n\033[1mUpdated DNS IP ($selected_nic): $new_dns\033[0m"
                    echo -e "\033[1mDNS changes applied. Press Enter to continue...\033[0m"; read -rp ""
                fi
            else
                echo "Invalid NIC choice. Press Enter to continue..."; read -rp ""
            fi
        fi
    else
        echo -e "\033[1mDNS changes canceled. Press Enter to continue...\033[0m"; read -rp ""
    fi
    ;;



        0) ;;
        *) echo "Invalid choice. Press Enter to continue..."; read -rp ""; ;;
        esac
        ;;
    0)

                     break
        ;;
    *)
        echo "Invalid choice. Press Enter to continue..."; read -rp ""
        ;;
    esac
done

