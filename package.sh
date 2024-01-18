#!/bin/bash

trap 'echo -e "\nExiting the Package Management Script. Goodbye!"; exit 0' SIGINT

while true; do
    clear
    echo ""
    echo "-------------------------------------------"
    echo "              Package Management"
    echo "-------------------------------------------"
    echo ""
    echo "1) Search for installed packages"
    echo "2) Download package"
    echo "3) Remove package"
    echo "4) Check for broken packages"
    echo "5) Remove all archived package files"
    echo "6) Remove packages that were automatically installed, no longer required"
    echo ""
    echo "0) --Back to Main Menu--"
    echo ""

    read -p "Enter your choice (0-6): " choice

    case $choice in
        0)

            break
            ;;
        1)
            read -p "Enter the package name to search: " package_name
            dpkg -l | grep $package_name || echo -e "\nNo installed packages matching '$package_name' found."
            ;;
        2)
            read -p "Enter the package name to download: " package_name
            sudo apt-get install $package_name
            if [ $? -eq 0 ]; then
                echo -e "\nPackage '$package_name' downloaded and installed successfully."
            else
                echo -e "\nError: Unable to install the package '$package_name'."
            fi
            ;;
        3)
            read -p "Enter the package name to remove: " package_name
            read -p "Are you sure you want to remove $package_name? (y/n): " confirm_remove
            if [ "$confirm_remove" == "y" ]; then
                sudo apt-get remove $package_name
                if [ $? -eq 0 ]; then
                    echo -e "\nPackage '$package_name' removed successfully."
                else
                    echo -e "\nError: Unable to remove the package '$package_name'."
                fi
            else
                echo "Removal canceled."
            fi
            ;;
        4)
            sudo apt-get check
            ;;
        5)
            sudo apt-get clean
            if [ $? -eq 0 ]; then
                echo -e "\nPackage cache cleaned successfully."
            else
                echo -e "\nError: Unable to clean the package cache."
            fi
            ;;
        6)
            sudo apt-get autoremove
            if [ $? -eq 0 ]; then
                echo -e "\nUnused packages removed successfully."
            else
                echo -e "\nError: Unable to remove unused packages."
            fi
            ;;
        *)
            echo -e "\nInvalid option. Please enter a number between 0 and 6."
            ;;
    esac

    read -p "Press Enter to continue..."
done

