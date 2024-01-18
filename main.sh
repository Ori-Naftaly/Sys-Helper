#!/bin/bash

get_joke_of_the_day() {
    # Replace 'YOUR_JOKE_API_ENDPOINT' with the actual endpoint of the joke API you want to use
    joke_api_endpoint='https://v2.jokeapi.dev/joke/Any'
    
    response=$(curl -s $joke_api_endpoint)
    joke=$(echo "$response" | awk -F'"' '/joke/ {print $4}')
    
    if [ -n "$joke" ]; then
        echo -e "\n$joke"
    else
        echo "Oops! Unable to fetch a joke today. API response:"
        echo "$response"
    fi
}


while true; do
    clear  # optional, clears the terminal for a cleaner menu display

    echo ""
echo "-------------------------------------------"
echo "              Welcome To SysHelper!"
echo "-------------------------------------------"
echo ""
    echo "1. System Information"
    echo "2. User and Group Management"
    echo "3. Filesystem Management"
    echo "4. Network Management"
    echo "5. Processes Management"
    echo "6. Services Management"
    echo "7. Logs and Real-Time View"
    echo "8. Backups Management"
    echo "9. Package Management"
    echo "10. Joke of the Day (3rd try is the charm)"  # Added option for Joke of the Day
    echo "0. Exit"

    read -p "Enter your choice: " choice

    case $choice in
        1) ./systeminfo.sh ;;
        2) ./usergroup.sh ;;
        3) ./filesystem.sh ;;
        4) ./network.sh ;;
        5) ./proces.sh ;;
        6) ./services.sh ;;
        7) ./logs.sh ;;
        8) ./backups.sh ;;                
        9) ./package.sh ;; 
        10) joke_of_the_day=$(get_joke_of_the_day)
            echo -e "Joke of the Day:\n$joke_of_the_day"
            ;;
        0) exit ;;
        *) echo "Invalid choice. Please enter a number between 0 and 10." ;;
    esac

    read -p "Press Enter to continue..."
done
