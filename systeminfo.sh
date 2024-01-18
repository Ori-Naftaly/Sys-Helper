#!/bin/bash

while true; do
    clear
    echo ""
echo "-------------------------------------------"
echo "              System Information"
echo "-------------------------------------------"
echo ""
    echo "1) General System Information"
    echo "2) Hardware Information"
    echo "3) User Information"
    echo "4) System Logs"
    echo "5) Filesystem Usage"
    echo "6) Open Calculator"
        echo "7) Open Calender"
    echo ""
    echo "0) --Back to Main Menu--"
    echo ""
    read -p "Enter your choice (1-9): " choice

    case $choice in
        1)
            # General System Information
            clear
            echo "--General System Information Menu--"
            echo ""
            echo "1) Display distribution-specific information"
            echo "2) Display system information, including the kernel version"
            echo ""
                        echo "0) --Back to Main Menu--"
                        echo ""
            
            read -p "Enter your choice (1-3): " sysInfoOption

            case $sysInfoOption in
                1)
                    lsb_release -a
                    read -p "Press enter to continue."
                    ;;
                2)
                    uname -a
                    read -p "Press enter to continue."
                    ;;
                0)
break
                    ;;

                *)
                    echo "Invalid option. Press enter to continue."
                    read
                    ;;
            esac
            ;;

        2)
            # Hardware Information
            clear
            echo "--Hardware Information Menu--"
            echo ""
            echo "1) List hardware information"
            echo "2) Display information about the CPU architecture"
            echo "3) List information about block devices (disks and partitions)"
            echo "4) Display information about PCI buses and devices"
                        echo "0) Exit"
            
            read -p "Enter your choice (1-4): " hardwareInfoOption

            case $hardwareInfoOption in
                1)
                    lshw
                    read -p "Press enter to continue."
                    ;;
                2)
                    lscpu
                    read -p "Press enter to continue."
                    ;;
                3)
                    lsblk
                    read -p "Press enter to continue."
                    ;;
                4)
                    lspci
                    read -p "Press enter to continue."
                    ;;
                                        0)
    # Exit back to the previous menu
    break
    ;;
                *)
                    echo "Invalid option. Press enter to continue."
                    read
                    ;;
            esac
            ;;

        3)
            # User Information
            clear
            echo "--User Information Menu--"
echo ""
            echo "1) Show a list of last logged in users"
            echo "2) List all users"
            echo "3) List all groups"
    
            read -p "Enter your choice (1-5): " userInfoOption

            case $userInfoOption in

1)
    # Show a list of last logged in users
    last
    read -p "Press enter to continue."
    ;;

2)
    # List all users on the system
    cut -d: -f1 /etc/passwd
    read -p "Press enter to continue."
    ;;

3)
    # List all groups on the system
    cut -d: -f1 /etc/group
    read -p "Press enter to continue."
    ;;
                *)
                    echo "Invalid option. Press enter to continue."
                    read
                    ;;
            esac
            ;;

        4)
            # System Logs
            clear
            echo "System Logs"
            journalctl
            read -p "Press enter to continue."
            ;;

        5)
            # Filesystem Usage

            echo "Filesystem Usage"
            df -h
            read -p "Press enter to continue."
            ;;

        6)
            # Calculator

            echo "Calculator"
            bc
            read -p "Press enter to continue."
            ;;
                            7)
                    timedatectl
                    read -p "Press enter to continue."
                    ;;

            
        0)
            echo "Exiting the System Monitoring Script. Goodbye!"
            break
            ;;

        *)
            echo "Invalid option. Press enter to continue."
            read
            ;;
    esac
done

