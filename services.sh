#!/bin/bash

while true; do
    clear
    echo ""
echo "-------------------------------------------"
echo "              Services Management"
echo "-------------------------------------------"
echo ""
    echo "1) Search Service"
    echo "2) View Logs for a service"
    echo "0) Exit"

    read -p "Enter your choice (1-3): " choice

    case $choice in
        1)
            read -p "Enter the service name: " serviceName
            systemctl status $serviceName
echo ""
            echo "Options:"
            echo ""
            echo "1) Start"
            echo "2) Stop"
            echo "3) Enable"
            echo "4) Disable"
            echo "5) Restart"
            echo ""
            echo "0) Back to main menu"
echo ""
            read -p "Enter your choice (1-6): " serviceOption

            case $serviceOption in
                1)
                    systemctl start $serviceName
                    ;;
                2)
                    systemctl stop $serviceName
                    ;;
                3)
                    systemctl enable $serviceName
                    ;;
                4)
                    systemctl disable $serviceName
                    ;;
                5)
                    systemctl restart $serviceName
                    ;;
                6)
                    continue
                    ;;
                *)
                    echo "Invalid option. Press enter to continue."
                    read
                    ;;
            esac

            systemctl status $serviceName
            read -p "Press enter to continue."
            ;;

        2)
            read -p "Enter the service name: " serviceName
            journalctl -u $serviceName

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

