#!/bin/bash

handle_error() {
    echo "Error: $1"
    read -p "Press Enter to continue..."
}

while true; do
    clear

    echo ""
echo "-------------------------------------------"
echo "              User and Group Management"
echo "-------------------------------------------"
echo ""
    echo ""
    echo "1. Users"
    echo "2. Groups"
    echo "3. Permissions"
    echo ""
    echo "0. --Back to Main Menu--"
    echo ""
    read -p "Enter your choice (1-4): " choice

    case $choice in
        1)
            while true; do
                clear
    echo ""
echo "-------------------------------------------"
echo "              User Management"
echo "-------------------------------------------"
echo ""
                echo "1. Create User"
                echo "2. Delete User"
                echo "3. Modify Group"
                echo "4. Change Password"
                echo "5. List all users"
                echo "6. Lock/Unlock User Account"
                echo "7. Expire/Unexpire User Password"
                echo "8. Display User Details"
                echo ""
                echo "0. Back to Main Menu"
                echo ""
                read -p "Enter your choice (1-9): " user_choice

                case $user_choice in
                    1)
                        read -p "Enter username to create: " username
                        sudo useradd $username && echo "User created successfully." || handle_error "Unable to create user."
                            read -p "Press Enter to continue..."
                        ;;
                    2)
                        read -p "Enter username to delete: " username
                        sudo userdel $username && echo "User deleted successfully." || handle_error "Unable to delete user."
                            read -p "Press Enter to continue..."
                        ;;
                    3)
                        read -p "Enter username to modify group: " username
                        read -p "Enter new group name: " new_group
                        sudo usermod -g $new_group $username && echo "Group modified successfully." || handle_error "Unable to modify group."
                            read -p "Press Enter to continue..."
                        ;;
                    4)
                        read -p "Enter username to change password: " username
                        sudo passwd $username && echo "Password changed successfully." || handle_error "Unable to change password."
                            read -p "Press Enter to continue..."
                        ;;
                    5)
                        echo "List of all users:"
                        getent passwd | cut -d: -f1
                        ;;
                    6)
                        read -p "Enter username to lock/unlock: " username
                        passwd -l $username && echo "User account locked/unlocked successfully." || handle_error "Unable to lock/unlock user account."
                            read -p "Press Enter to continue..."
                        ;;
                    7)
  				  manage_password_aging() {
					local username=$1

					# Display current password aging information
					echo "Current password aging information for $username:"
					chage -l $username

					# Provide options for password aging changes
					echo -e "\nChoose an option:"
					echo -e "\n"
					echo "1) New expiration date"
					echo "2) How many days after a password expires"
					echo "3) Minimum number of days between password changes"
					echo "4) Maximum number of days during which a password is valid"
					read -p "Enter your choice (1-4): " aging_choice
					

        case $aging_choice in
            1)
                read -p "Enter new expiration date (YYYY-MM-DD): " new_exp_date
                chage -E $new_exp_date $username
                ;;
            2)
                read -p "Enter number of days after password expires until account is permanently disabled: " days_disabled
                chage -I $days_disabled $username
                ;;
            3)
                read -p "Enter minimum number of days between password changes: " min_days
                chage -m $min_days $username
                ;;
            4)
                read -p "Enter maximum number of days during which a password is valid: " max_days
                chage -M $max_days $username
                ;;
            *)
                handle_error "Invalid choice. Please enter a number between 1 and 4."
                ;;
        esac

        # Display new password aging information
        echo -e "\nNew password aging information for $username:"
        chage -l $username
    }

    read -p "Enter username to manage password aging: " username
    manage_password_aging $username

    read -p "Press Enter to continue..."
    ;;
                    8)
                        read -p "Enter username to display details: " username
                        id $username && chage -l $username || handle_error "Unable to display user details."
                            read -p "Press Enter to continue..."
                        ;;
                    0)
                        break
                        ;;
                    *)
                        handle_error "Invalid choice. Please enter a number between 1 and 9."
                        ;;
                esac
            done
            ;;
        2)
            while true; do
                clear
    echo ""
echo "-------------------------------------------"
echo "              Group Management"
echo "-------------------------------------------"
echo ""
                echo "1. Create Group"
                echo "2. Delete Group"
                echo "3. Remove user from group"
                echo "4. List groups for user"
                echo "5. Add Users to Multiple Groups"
                echo "6. List Members of a Group"
                echo "7. Display Group Details"
                echo ""
                echo "0. Back to Main Menu"
                echo ""
                read -p "Enter your choice (1-8): " group_choice

                case $group_choice in
                    1)
                        read -p "Enter group name to create: " group_name
                        sudo groupadd $group_name && echo "Group created successfully." || handle_error "Unable to create group."
                        ;;
                    2)
                        read -p "Enter group name to delete: " group_name
                        sudo groupdel $group_name && echo "Group deleted successfully." || handle_error "Unable to delete group."
                        ;;
                    3)
                        read -p "Enter username: " username
                        read -p "Enter group name to remove user from: " group_name
                        sudo deluser $username $group_name && echo "User removed from group successfully." || handle_error "Unable to remove user from group."
                        ;;
                    4)
                        read -p "Enter username: " username
                        groups $username || handle_error "Unable to list groups for user."
                        ;;
                    5)
                        read -p "Enter username: " username
                        read -p "Enter groups (comma-separated): " groups
                        IFS=',' read -ra group_array <<< "$groups"
                        for group in "${group_array[@]}"; do
                            sudo usermod -aG $group $username
                        done
                        echo "User added to groups successfully."
                            read -p "Press Enter to continue..."
                        ;;
                    6)
                        read -p "Enter group name to list members: " group_name
                        members=$(getent group $group_name | cut -d: -f4)
                        echo "Members of group $group_name: $members" || handle_error "Unable to list members of group."
                            read -p "Press Enter to continue..."
                        ;;
                    7)
                        read -p "Enter group name to display details: " group_name
                        getent group $group_name || handle_error "Unable to display group details."
                            read -p "Press Enter to continue..."
                        ;;
                    0)
                        break
                        ;;
                    *)
                        handle_error "Invalid choice. Please enter a number between 1 and 8."
                        ;;
                esac
            done
            ;;
        3)
            while true; do
                clear
    echo ""
echo "-------------------------------------------"
echo "              Permissions Management"
echo "-------------------------------------------"
echo ""
                echo "1. Change file permissions for a user"
                echo "2. Change folder permissions for a user"
                echo "3. Change file permissions for a group"
                echo "4. Change folder permissions for a group"
                echo "5. View file permissions (rwx and octal)"
                echo "6. View folder permissions (rwx and octal)"
                echo ""
                echo "0. Back to Main Menu"
                echo ""
                read -p "Enter your choice (1-7): " perm_choice

                case $perm_choice in
                    1)
                        read -p "Enter username: " username
                        read -p "Enter full path to filename: " filename
                        echo "Choose permission: "
                        echo "1) Read"
                        echo "2) Write"
                        echo "3) Execute"
                        echo "4) Read and Write"
                        echo "5) Read and Execute"
                        echo "6) Write and Execute"
                        echo "7) Read, Write and Execute"
                        echo "8) No permission"
                        read -p "Enter your choice (1-8): " permission_choice

                        case $permission_choice in
                            1) permissions="r" ;;
                            2) permissions="w" ;;
                            3) permissions="x" ;;
                            4) permissions="rw" ;;
                            5) permissions="rx" ;;
                            6) permissions="wx" ;;
                             7) permissions="rwx" ;;
                            8) permissions="" ;;  # No permission
                            *) echo "Invalid choice. Please enter a number between 1 and 8." ;;
                        esac

                        if [ -z "$permissions" ]; then
                            sudo chmod u= "$filename" && echo "Permissions changed successfully." || echo "Unable to change permissions."
                        else
                            sudo chmod u="$permissions" "$filename" && echo "Permissions changed successfully." || echo "Unable to change permissions."
                        fi

                        echo "New permissions for $filename: $(ls -l "$filename" | awk '{print $1}')"
                            read -p "Press Enter to continue..."
                        ;;

                    2)
                        read -p "Enter username: " username
                        read -p "Enter full path to folder: " foldername
                        echo "Choose permission: "
                        echo "1) Read"
                        echo "2) Write"
                        echo "3) Execute"
                        echo "4) Read and Write"
                        echo "5) Read and Execute"
                        echo "6) Write and Execute"
                        echo "7) Read, Write and Execute"
                        echo "8) No permissions"
                        read -p "Enter your choice (1-8): " permission_choice

                        case $permission_choice in
                            1) permissions="r" ;;
                            2) permissions="w" ;;
                            3) permissions="x" ;;
                            4) permissions="rw" ;;
                            5) permissions="rx" ;;
                            6) permissions="wx" ;;
                            7) permissions="rwx" ;;
                            8) permissions="" ;;  # No permission
                            *) echo "Invalid choice. Please enter a number between 1 and 8." ;;
                        esac

                        sudo chmod u="$permissions" "$foldername" && echo "Permissions changed successfully." || echo "Unable to change permissions."
                        echo "New permissions for $foldername: $(ls -ld "$foldername" | awk '{print $1}')"
                            read -p "Press Enter to continue..."
                        ;;

                    3)
                        read -p "Enter group name: " groupname
                        read -p "Enter full path to file: " filename
                        echo "Choose permission: "
                        echo "1) Read"
                        echo "2) Write"
                        echo "3) Execute"
                        echo "4) Read and Write"
                        echo "5) Read and Execute"
                        echo "6) Write and Execute"
                        echo "7) Read, Write and Execute"
                        echo "8) No permission"
                        read -p "Enter your choice (1-8): " permission_choice

                        case $permission_choice in
                            1) permissions="r" ;;
                            2) permissions="w" ;;
                            3) permissions="x" ;;
                            4) permissions="rw" ;;
                            5) permissions="rx" ;;
                            6) permissions="wx" ;;
                            7) permissions="rwx" ;;
                            8) permissions="" ;;  # No permission
                            *) echo "Invalid choice. Please enter a number between 1 and 8." ;;
                        esac

                        if [ -z "$permissions" ]; then
                            sudo chmod g= "$filename" && echo "Permissions changed successfully." || echo "Unable to change permissions."
                        else
                            sudo chmod g="$permissions" "$filename" && echo "Permissions changed successfully." || echo "Unable to change permissions."
                        fi

                        echo "New permissions for $filename: $(ls -l "$filename" | awk '{print $1}')"
                            read -p "Press Enter to continue..."
                        ;;

                    4)
                        read -p "Enter group name: " groupname
                        read -p "Enter full path to folder: " foldername
                        echo "Choose permission: "
                        echo "1) Read"
                        echo "2) Write"
                        echo "3) Execute"
                        echo "4) Read and Write"
                        echo "5) Read and Execute"
                        echo "6) Write and Execute"
                        echo "7) Read, Write and Execute"
                        echo "8) No permissions"
                        read -p "Enter your choice (1-8): " permission_choice

                        case $permission_choice in
                            1) permissions="r" ;;
                            2) permissions="w" ;;
                            3) permissions="x" ;;
                            4) permissions="rw" ;;
                            5) permissions="rx" ;;
                            6) permissions="wx" ;;
                            7) permissions="rwx" ;;
                            8) permissions="" ;;  # No permission
                            *) echo "Invalid choice. Please enter a number between 1 and 8." ;;
                        esac

                        sudo chmod g="$permissions" "$foldername" && echo "Permissions changed successfully." || echo "Unable to change permissions."
                        echo "New permissions for $foldername: $(ls -ld "$foldername" | awk '{print $1}')"
                            read -p "Press Enter to continue..."
                        ;;

                    5)
                        read -p "Enter full path to file: " filename
                        echo "File permissions for $filename: $(ls -l "$filename" | awk '{print $1}')"
                            read -p "Press Enter to continue..."
                        ;;

                    6)
                        read -p "Enter full path to folder: " foldername
                        echo "Folder permissions for $foldername: $(ls -ld "$foldername" | awk '{print $1}')"
                            read -p "Press Enter to continue..."
                        ;;

                    0)
                        break
                        ;;

                    *)
                        handle_error "Invalid choice. Please enter a number between 1 and 7."
                        ;;
                esac
            done
            ;;
        0)
        echo "Exiting the System Monitoring Script. Goodbye!"
                     break
            ;;
        *)
            handle_error "Invalid choice. Please enter a number between 1 and 4."
            ;;
    esac
done

