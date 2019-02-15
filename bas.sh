#!/bin/bash

# Set up SSH
read -p "Enter your email address: " email
read -p "Do you want to use 'ed25519' or 'rsa4096'? " -r key_type

if [[ $key_type =~ ^(E|e)d25519$ ]]; then
    ssh-keygen -t ed25519 -C "$email"
elif [[ $key_type =~ ^(R|r)sa4096$ ]]; then
    ssh-keygen -t rsa -b 4096 -C "$email"
else
    echo "Invalid input. Please choose either 'ed25519' or 'rsa4096'."
    exit 1
fi

# Add SSH key to ssh-agent
eval "$(ssh-agent -s)"
read -p "Enter the path to your SSH key (default: /home/yourname/.ssh/id_ed25519): " -r ssh_key

if [[ $ssh_key =~ ^$ ]]; then
    ssh_key="/home/$USER/.ssh/id_ed25519"
fi

if [[ -f $ssh_key ]]; then
    ssh-add "$ssh_key"
    echo "SSH key added to ssh-agent."
else
    echo "File not found. Please check the path to your SSH key."
    exit 1
fi

echo "Done!"