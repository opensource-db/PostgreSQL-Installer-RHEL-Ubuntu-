**A Bash script to install PostgreSQL on multiple Linux distributions.
**
**Supports:
**
RHEL / Rocky Linux / AlmaLinux
Ubuntu
Features
Install PostgreSQL versions 15, 16, 17, 18
Automatic OS detection
Supports x86_64 / amd64 architecture
Uses official PostgreSQL (PGDG) repositories
Installs only the selected PostgreSQL version
Initializes database (RHEL-based systems)
Starts and enables the PostgreSQL service
** Requirements
** 
Root or sudo access
**Supported OS:
**
RHEL / Rocky / AlmaLinux
Ubuntu
**Internet connection
**
Usage
1. Clone the repository
git clone https://github.com/your-username/your-repo.git
cd your-repo
2. Make the script executable
chmod +x install_postgres.sh
3. Run the script
sudo ./install_postgres.sh

**During execution, you will be prompted to enter the PostgreSQL version:
**
**Enter PostgreSQL version to install (15/16/17/18):
**
What the Script Does
**For RHEL-based systems:
**
Installs PGDG repository
Disables the default PostgreSQL module
Enables selected version repository
**Installs:
**
postgresql-server
postgresql-contrib
Initializes database cluster
Starts PostgreSQL service
**For Ubuntu:
**
Adds PostgreSQL APT repository
Imports GPG key
**Installs:
**
postgresql
postgresql-contrib
Starts PostgreSQL service
 Verification

**Check installed version:
**
psql --version
 Notes
Script must be run as root
Only supports x86_64 / amd64
Existing PostgreSQL installations may conflict
License

This project is open-source and available under the MIT License.
