#! /usr/bin/env bash
set -e
###########################################################################
#
# Nginx Bootstrap Installer
# https://github.com/polymimetic/ansible-role-nginx
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/ansible-role-nginx/master/install.sh | bash
#
###########################################################################

if [ `id -u` = 0 ]; then
  printf "\033[1;31mThis script must NOT be run as root\033[0m\n" 1>&2
  exit 1
fi

###########################################################################
# Constants and Global Variables
###########################################################################

readonly GIT_REPO="https://github.com/polymimetic/ansible-role-nginx.git"
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/ansible-role-nginx/master"

###########################################################################
# Basic Functions
###########################################################################

# Output Echoes
# https://github.com/cowboy/dotfiles
function e_error()   { echo -e "\033[1;31m✖  $@\033[0m";     }      # red
function e_success() { echo -e "\033[1;32m✔  $@\033[0m";     }      # green
function e_info()    { echo -e "\033[1;34m$@\033[0m";        }      # blue
function e_title()   { echo -e "\033[1;35m$@.......\033[0m"; }      # magenta

###########################################################################
# Install Nginx
# https://www.nginx.com/
#
# https://www.linuxbabe.com/linux-server/install-nginx-mariadb-php7-lemp-stack-ubuntu-16-04-lts
###########################################################################

install_nginx() {
  e_title "Installing Nginx"

  # Add nginx PPA
  if ! grep -q "nginx/development" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:nginx/development
    sudo apt-get update
  fi

  # Install nginx webserver
  sudo apt-get install -yq nginx

  # Remove the default symlink in sites-enabled directory
  sudo rm /etc/nginx/sites-enabled/default

  # Enable nginx to auto start
  sudo systemctl enable nginx

  # Start nginx
  sudo systemctl start nginx

  e_success "Nginx installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_nginx
}

program_start