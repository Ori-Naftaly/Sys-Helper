#!/bin/bash

while true; do
    clear
    echo ""
echo "-------------------------------------------"
echo "              File System Management"
echo "-------------------------------------------"
echo ""
    echo "1. Find a file or folder"
    echo "2. Show size for file or folder"
    echo "3. Display all information about mounted file systems"
    echo "4. Show largest files in the system"
    echo "5. Show disk usage and free space on each disk"
    echo "6. Zip and unzip files"
    echo "7. Checking File or folder Access Times"
    echo "8. Checking for Duplicate Files"
    echo ""
    echo "0. --Back to Main Menu--"
echo ""
    read -p "Enter your choice (0-8): " choice

    case $choice in
        [0-8])
            ;;
        *)
            echo "Invalid choice. Please enter a number between 0 and 8."
            read -p "Press Enter to continue..."
            continue
            ;;
    esac

    case $choice in
        1)
            # Logic for option 1 - Find a file or folder
            read -p "Enter the text to search for in files or folders: " search_text

            echo "Search results for '$search_text':"
            find / -type f -name "*$search_text*" 2>/dev/null
            find / -type d -name "*$search_text*" 2>/dev/null

            read -p "Press Enter to continue..."
            ;;

        2)
            # Logic for option 2 - Show size for file or folder
            read -p "Enter the path to the file or folder: " size_path

            if [ -e "$size_path" ]; then
                if [ -f "$size_path" ]; then
                    echo "Size of the file '$size_path':"
                    du -h "$size_path"
                elif [ -d "$size_path" ]; then
                    echo "Size of the folder '$size_path':"
                    du -h --max-depth=1 "$size_path"
                else
                    echo "Unknown file type."
                fi
            else
                echo "File or folder not found."
            fi

            read -p "Press Enter to continue..."
            ;;
        3)
            # Logic for option 3 - Display all information about mounted file systems
            df -h
            read -p "Press Enter to continue..."
            ;;
        4)
    # Logic for option 4 - Show largest files in the system
    while true; do
        clear
        echo "Option 5: Show largest files in the system"
        echo ""
        echo "1. Files larger than 50MB"
        echo "2. Files larger than 100MB"
        echo "3. Files larger than 500MB"
        echo "4. Files larger than 1GB"
        echo "0. Go back to main menu"

        read -p "Enter your choice (0-4): " size_choice

        case $size_choice in
            [0-4])
                ;;
            *)
                echo "Invalid choice. Please enter a number between 0 and 4."
                read -p "Press Enter to continue..."
                continue
                ;;
        esac

        case $size_choice in
            1)
                # Logic for option 5 - Submenu 1
                echo "Largest files in the system over 50MB:"
                largest_files=$(find / -type f -size +50M -exec du -h --max-depth=1 {} + 2>/dev/null | sort -rh)
                echo "$largest_files"
                read -p "Do you want to remove a file? (y/n): " remove_option

                case $remove_option in
                    [Yy])
                        read -p "Enter the path of the file to remove: " file_to_remove
                        if [ -e "$file_to_remove" ]; then
                            rm -i "$file_to_remove"
                            echo "File removed successfully."
                        else
                            echo "File not found."
                        fi
                        ;;
                    *)
                        ;;
                esac

                read -p "Press Enter to continue..."
                ;;
            2)
                # Logic for option 5 - Submenu 2
                echo "Largest files in the system over 100MB:"
                largest_files=$(find / -type f -size +100M -exec du -h --max-depth=1 {} + 2>/dev/null | sort -rh)
                echo "$largest_files"
                read -p "Do you want to remove a file? (y/n): " remove_option

                case $remove_option in
                    [Yy])
                        read -p "Enter the path of the file to remove: " file_to_remove
                        if [ -e "$file_to_remove" ]; then
                            rm -i "$file_to_remove"
                            echo "File removed successfully."
                        else
                            echo "File not found."
                        fi
                        ;;
                    *)
                        ;;
                esac

                read -p "Press Enter to continue..."
                ;;
            3)
                # Logic for option 4 - Submenu 3
                echo "Largest files in the system over 500MB:"
                largest_files=$(find / -type f -size +500M -exec du -h --max-depth=1 {} + 2>/dev/null | sort -rh | head -n 100)
                echo "$largest_files"
                read -p "Do you want to remove a file? (y/n): " remove_option

                case $remove_option in
                    [Yy])
                        read -p "Enter the path of the file to remove: " file_to_remove
                        if [ -e "$file_to_remove" ]; then
                            rm -i "$file_to_remove"
                            echo "File removed successfully."
                        else
                            echo "File not found."
                        fi
                        ;;
                    *)
                        ;;
                esac

                read -p "Press Enter to continue..."
                ;;
            4)
                # Logic for option 4 - Submenu 4
                echo "Largest files in the system over 1GB:"
                largest_files=$(find / -type f -size +1G -exec du -h --max-depth=1 {} + 2>/dev/null | sort -rh | head -n 100)
                echo "$largest_files"
                read -p "Do you want to remove a file? (y/n): " remove_option

                case $remove_option in
                    [Yy])
                        read -p "Enter the path of the file to remove: " file_to_remove
                        if [ -e "$file_to_remove" ]; then
                            rm -i "$file_to_remove"
                            echo "File removed successfully."
                        else
                            echo "File not found."
                        fi
                        ;;
                    *)
                        ;;
                esac

                read -p "Press Enter to continue..."
                ;;
            0)
                break
                ;;
        esac
    done
    ;;

        5)
            # Logic for option 5 - Show disk usage and free space on each disk
            df -h
            read -p "Press Enter to continue..."
            ;;

        6)
            # Submenu for option 6 - Zip and unzip files
            while true; do
                clear
                echo "Zip and unzip files"
                echo ""
                echo "1. Zip a file or folder"
                echo "2. Unzip a file or folder"
                echo "0. Go back to main menu"

                read -p "Enter your choice (0-2): " zip_unzip_choice

                case $zip_unzip_choice in
                    [0-2])
                        ;;
                    *)
                        echo "Invalid choice. Please enter a number between 0 and 2."
                        read -p "Press Enter to continue..."
                        continue
                        ;;
                esac

                case $zip_unzip_choice in
                    1)
                        # Logic for option 6 - Submenu 1 (Zip a file or folder)
                        read -p "Enter the path to the file or folder to zip: " zip_source
                        if [ -e "$zip_source" ]; then
                            read -p "Enter the path to save the zipped file (including name): " zip_destination
                            zip -r "$zip_destination" "$zip_source" -p
                            echo "Zipping completed. Permissions preserved."
                            ls -ltr "$zip_destination"
                            read -p "Press Enter to continue..."
                        else
                            echo "File or folder not found."
                            read -p "Press Enter to continue..."
                        fi
                        ;;
                    2)
                        # Logic for option 6 - Submenu 2 (Unzip a file or folder)
                        read -p "Enter the path to the zipped file: " unzip_source
                        if [ -e "$unzip_source" ]; then
                            read -p "Enter the path to extract the contents: " unzip_destination
                            mkdir -p "$unzip_destination"
                            unzip "$unzip_source" -d "$unzip_destination" -K
                            echo "Unzipping completed. Permissions preserved."
                            ls -ltr "$unzip_destination"
                            read -p "Press Enter to continue..."
                        else
                            echo "Zipped file not found."
                            read -p "Press Enter to continue..."
                        fi
                        ;;
                    0)
                        break
                        ;;
                esac
            done
            ;;
        7)
            # Logic for option 7 - Checking File or Folder Access Times
            read -p "Enter the path to the file or folder: " access_path

            if [ -e "$access_path" ]; then
                echo "Access times for '$access_path':"
                echo ""

                # Get access times
                access_times=$(stat -c "%x %y %z" "$access_path")

                # Process and display in a user-friendly list
                IFS=' ' read -ra times <<< "$access_times"
                echo -e "Last Access Time: ${times[0]}\nLast Modification Time: ${times[1]}\nLast Status Change Time: ${times[2]}"
            else
                echo "File or folder not found."
            fi
            echo ""

            read -p "Press Enter to continue..."
            ;;

        8)
            # Logic for option 9 - Checking for Duplicate Files
            # Add your logic for checking duplicate files here
            ;;

        0)
            echo "Exiting File System Menu. Goodbye!"
             break
            ;;
    esac
done
