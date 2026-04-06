#!/bin/bash

set -e

echo "=========================================="
echo " Universal PostgreSQL Installer"
echo " RHEL / Rocky / Alma / Ubuntu"
echo "=========================================="

# Must run as root
if [[ $EUID -ne 0 ]]; then
   echo "Please run as root"
   exit 1
fi

ARCH=$(uname -m)

if [[ "$ARCH" != "x86_64" && "$ARCH" != "amd64" ]]; then
    echo "This script currently supports x86_64/amd64 only."
    exit 1
fi

# Ask PostgreSQL version
read -p "Enter PostgreSQL version to install (15/16/17/18): " PG_VERSION

if [[ -z "$PG_VERSION" ]]; then
    echo "Invalid version!"
    exit 1
fi

# Detect OS
if [ -f /etc/redhat-release ]; then
    OS_FAMILY="rhel"
    OS_VERSION=$(rpm -E %{rhel})
elif [ -f /etc/lsb-release ] || [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "ubuntu" ]]; then
        OS_FAMILY="ubuntu"
        UBUNTU_CODENAME=$VERSION_CODENAME
    fi
else
    echo "Unsupported OS"
    exit 1
fi

echo
echo "Detected OS Family: $OS_FAMILY"
echo "Detected Architecture: $ARCH"
echo "Installing PostgreSQL $PG_VERSION..."
echo

############################################
# RHEL / ROCKY / ALMA
############################################
if [[ "$OS_FAMILY" == "rhel" ]]; then

    dnf -y install dnf-plugins-core

    # Install PGDG repo
    dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-${OS_VERSION}-x86_64/pgdg-redhat-repo-latest.noarch.rpm

    # Disable built-in module
    dnf -qy module disable postgresql || true

    # Disable all pgdg repos first
    dnf config-manager --set-disabled pgdg*

    # Enable only required version repo
    dnf config-manager --set-enabled pgdg${PG_VERSION}

    # Install selected version ONLY
    dnf install -y postgresql${PG_VERSION}-server postgresql${PG_VERSION}-contrib

    # Initialize DB
    /usr/pgsql-${PG_VERSION}/bin/postgresql-${PG_VERSION}-setup initdb

    systemctl enable postgresql-${PG_VERSION}
    systemctl start postgresql-${PG_VERSION}


############################################
# UBUNTU
############################################
elif [[ "$OS_FAMILY" == "ubuntu" ]]; then

    apt update
    apt install -y wget gnupg2 lsb-release curl

    # Add PGDG repo
    echo "deb http://apt.postgresql.org/pub/repos/apt ${UBUNTU_CODENAME}-pgdg main" \
        > /etc/apt/sources.list.d/pgdg.list

    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor \
        -o /etc/apt/trusted.gpg.d/postgresql.gpg

    apt update

    # Install selected version only
    apt install -y postgresql-${PG_VERSION} postgresql-contrib-${PG_VERSION}

    systemctl enable postgresql
    systemctl start postgresql

else
    echo "Unsupported OS"
    exit 1
fi

echo
echo "=========================================="
echo " PostgreSQL $PG_VERSION Installed Successfully"
echo "=========================================="
psql --version


