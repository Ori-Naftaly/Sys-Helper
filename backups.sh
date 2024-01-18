#!/bin/bash

# Function to display menu
display_menu() {
    clear
    echo ""
echo "-------------------------------------------"
echo "        Backups and Cronjobs Management"
echo "-------------------------------------------"
echo ""
    echo "1. Backup Specific Directories"
    echo "2. Backup User Home Folder"
    echo "3. Configure Cron Job"
    echo "4. View Cron Jobs for User"
    echo ""
    echo "0. Back to Main Menu"
    echo ""
}

# Function for specific directories backup
backup_specific_directories() {
    while true; do
        # Ask user for the path to the folder
        read -p "Enter the path to the folder to backup: " folder_path

        # Check if the folder exists
        if [ -d "$folder_path" ]; then
            echo "Folder found."
            break
        else
            echo "Folder not found. Please try again."
        fi
    done

    while true; do
        # Ask user where they want to save the backup
        backup_path_prompt "Enter the path to store the backup: "

        # Check if the backup path exists
        if [ -d "$backup_path" ]; then
            echo "Backup path exists."
            break
        else
            echo "Backup path does not exist. Please try again."
        fi
    done

    filename_prompt

    # Perform the backup using zipping
    echo "Backing up specified folder to $backup_path/$filename.tar.gz..."
    if sudo tar -czvf "$backup_path/$filename.tar.gz" -C "$folder_path" .; then
        echo "Backup complete!"
        # Give backup rwx permissions to the user logged in
        sudo chmod u+rwx "$backup_path/$filename.tar.gz"
    else
        echo "Backup failed! Please check the error message above."
    fi

    # Display ls -ltr on the chosen backup path
    echo "Contents of $backup_path after backup:"
    ls -ltr "$backup_path" || echo "Failed to list contents of $backup_path"

    # Prompt user to see the output
    read -p "Press Enter to continue..."
}

# Function to backup user home folder
backup_user_home() {
    read -p "Enter the username to backup home folder: " username

    while true; do
        # Ask user where they want to save the backup
        backup_path_prompt "Enter the path to store the backup: "

        # Check if the backup path exists
        if [ -d "$backup_path" ]; then
            echo "Backup path exists."
            break
        else
            echo "Backup path does not exist. Please try again."
        fi
    done

    filename_prompt

    # Perform the backup using zipping
    echo "Backing up user $username home folder to $backup_path/$filename.tar.gz..."
    if sudo tar -czvf "$backup_path/$filename.tar.gz" -C /home/ "$username"; then
        echo "Backup complete!"
        # Give backup rwx permissions to the user logged in
        sudo chmod u+rwx "$backup_path/$filename.tar.gz"
    else
        echo "Backup failed! Please check the error message above."
    fi

    # Display ls -ltr on the chosen backup path
    echo "Contents of $backup_path after backup:"
    ls -ltr "$backup_path" || echo "Failed to list contents of $backup_path"

    # Prompt user to see the output
    read -p "Press Enter to continue..."
}

# Function to validate cron schedule
validate_cron_schedule() {
    # Validate cron schedule format
    if [[ ! $1 =~ ^[0-9*,-/]+$ ]]; then
        echo "Invalid cron schedule format. Please use numbers, '*', ',', '-', and '/'."
        return 1
    fi

    return 0
}

# Function to validate cron command
validate_cron_command() {
    # Validate cron command format
    if [[ -z "$1" ]]; then
        echo "Cron command cannot be empty. Please provide a valid command."
        return 1
    fi

    return 0
}

# Function to configure cron job
configure_cron_job() {
    echo "Configure Cron Job:"
    echo "-------------------"

    # Display cron syntax in a table
    echo "+----------------+-------------------------------------+"
    echo "| Cron Field     | Explanation                         |"
    echo "+----------------+-------------------------------------+"
    echo "| minute         | 0-59                                |"
    echo "| hour           | 0-23                                |"
    echo "| day            | 1-31                                |"
    echo "| month          | 1-12                                |"
    echo "| day_of_week    | 0-6 (Sunday to Saturday, 7 is Sunday)|"
    echo "+----------------+-------------------------------------+"
    echo ""
    echo "For example, '0 2 * * *' runs daily at 2:00 AM"
    echo "Use '*' to represent any value, e.g., '*' in the 'day' field means every day."
    echo ""

    PS3="Choose a predefined cron job option (or 'q' to quit): "
    options=("Every Day at Midnight" "Every Hour" "Every Sunday" "Every 15 Minutes" "Every Month on the 1st" "Custom Schedule" "Quit")

    select opt in "${options[@]}"; do
        case $opt in
            "Every Day at Midnight")
                schedule="0 0 * * *"
                break
                ;;
            "Every Hour")
                schedule="0 * * * *"
                break
                ;;
            "Every Sunday")
                schedule="0 0 * * 0"
                break
                ;;
            "Every 15 Minutes")
                schedule="*/15 * * * *"
                break
                ;;
            "Every Month on the 1st")
                schedule="0 0 1 * *"
                break
                ;;
            "Custom Schedule")
                while true; do
                    # Ask user for cron schedule
                    read -p "Enter the cron schedule: " schedule
                    validate_cron_schedule "$schedule" && break
                done
                ;;
            "Quit")
                return
                ;;
            *) echo "Invalid option. Please choose a valid option." ;;
        esac
    done

    while true; do
        # Ask user for the path to the script
        read -p "Enter the path to the script: " script_path
        if [ -f "$script_path" ]; then
            break
        else
            echo "Script not found at '$script_path'. Please provide a valid script path."
        fi
    done

    # Confirm user input
    echo ""
    echo "You have configured the cron job to run the following schedule:"
    echo "Minute:        Hour:          Day:           Month:         Day of Week:"
    echo "$schedule"

    echo "Command to run: $script_path"
    echo ""
    read -p "Do you want to proceed with this configuration? (yes/no): " confirmation

    case $confirmation in
        [Yy]|[Yy][Ee][Ss]) ;;
        *) echo "Cron job configuration aborted."; return ;;
    esac

    # Add the cron job
    if (crontab -l 2>/dev/null; echo "$schedule $script_path") | crontab -; then
        echo "Cron job configured successfully!"
        echo "Use 'crontab -l' to view your current cron jobs."
    else
        echo "Error configuring cron job. Please check your input and try again."
    fi

    # Prompt user to see the output
    read -p "Press Enter to continue..."
}

# Function to view cron jobs for a specific user
view_cron_jobs_for_user() {
    read -p "Enter the username to view cron jobs: " username
    crontab -u "$username" -l 2>/dev/null
    read -p "Press Enter to continue..."
}



# Main script logic
while true; do
    display_menu
    read -p "Enter your choice (1-6): " choice

    case $choice in
        1) backup_specific_directories ;;
        2) backup_user_home ;;
        3) configure_cron_job ;;
        4) view_cron_jobs_for_user ;;
        6) echo "Exiting script. Goodbye!";  exec "$0"  ;;
        *) echo "Invalid choice. Please enter a number between 1 and 6." ;;
    esac
done

# Function to prompt user for backup path
backup_path_prompt() {
    read -p "$1" backup_path
    # Ensure the path ends with a slash
    backup_path="${backup_path%/}/"
}

# Function to prompt user for filename
filename_prompt() {
    read -p "Enter the filename for the backup (without extension): " filename
    read -p "Press Enter to continue..."
}

## Main script logic
while true; do
    display_menu
    read -p "Enter your choice (1-6): " choice

case $choice in
    1) backup_specific_directories ;;
    2) backup_user_home ;;
    3) configure_cron_job ;;
    4) view_cron_jobs_for_user ;;
    0) echo "Exiting script. Goodbye!"; exec "$0" ;;
    *) echo "Invalid choice. Please enter a number between 1 and 6." ;;
esac
done



