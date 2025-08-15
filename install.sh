#!/bin/bash

# ═══════════════════════════════════════════════════════════════════
# Laravel Server Complete Auto Installer - Nginx Edition (Fixed)
# Version: 5.3 - Symlink Fix
# Compatible with: Ubuntu 20.04/22.04
# ═══════════════════════════════════════════════════════════════════

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

# Log file
LOG_FILE="/var/log/laravel-installer-$(date +%Y%m%d_%H%M%S).log"
CREDENTIALS_FILE="/root/server-credentials.txt"

# Global variables
MAIN_DOMAIN=""
SSL_EMAIL=""
MYSQL_ROOT_PASS=""
SERVER_IP=""
REDIS_PASS=""
PMA_PASS=""

# Message functions
print_message() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')] ✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}[WARNING] ⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}[ERROR] ✗ $1${NC}"
}

print_info() {
    echo -e "${CYAN}[INFO] ℹ $1${NC}"
}

# Check root access
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root!"
        exit 1
    fi
}

# Show banner
show_banner() {
    clear
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║     🚀 Laravel Server Auto Installer v5.3 🚀                ║"
    echo "║                                                              ║"
    echo "║  Installing:                                                 ║"
    echo "║  • Nginx + PHP-FPM 8.3                                      ║"
    echo "║  • MySQL + phpMyAdmin                                       ║"
    echo "║  • Redis + Memcached                                        ║"
    echo "║  • Composer + Node.js + Yarn                                ║"
    echo "║  • Let's Encrypt SSL                                        ║"
    echo "║  • Security + Backup                                        ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Get server IP
get_server_ip() {
    SERVER_IP=$(curl -4 -s ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}')
    if [[ -z "$SERVER_IP" ]]; then
        read -p "Enter server IP: " SERVER_IP
    fi
    print_info "Server IP: $SERVER_IP"
}

# Generate passwords
generate_passwords() {
    MYSQL_ROOT_PASS=$(openssl rand -base64 16 | tr -d "=+/" | cut -c1-16)
    REDIS_PASS=$(openssl rand -base64 12 | tr -d "=+/" | cut -c1-12)
    PMA_PASS=$(openssl rand -base64 12 | tr -d "=+/" | cut -c1-12)
}

# Get user input
get_user_input() {
    print_message "Configuration Setup"
    
    get_server_ip
    
    # Get domain
    read -p "Enter main domain (e.g., example.com): " MAIN_DOMAIN
    if [[ -z "$MAIN_DOMAIN" ]]; then
        MAIN_DOMAIN="server.local"
    fi
    
    # Get email
    read -p "Enter email for SSL (e.g., admin@$MAIN_DOMAIN): " SSL_EMAIL
    if [[ -z "$SSL_EMAIL" ]]; then
        SSL_EMAIL="admin@$MAIN_DOMAIN"
    fi
    
    # Generate passwords
    generate_passwords
    
    # Show summary
    echo ""
    print_info "Configuration Summary:"
    echo "  Domain: $MAIN_DOMAIN"
    echo "  Email: $SSL_EMAIL"
    echo "  Server IP: $SERVER_IP"
    echo ""
    
    read -p "Continue with installation? (y/n): " CONFIRM
    if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
        print_error "Installation cancelled"
        exit 1
    fi
}

# Step 1: System preparation
prepare_system() {
    print_message "Step 1/10: Preparing system..."
    
    export DEBIAN_FRONTEND=noninteractive
    apt update -y
    apt upgrade -y
    
    apt install -y curl wget git unzip software-properties-common \
        apt-transport-https ca-certificates gnupg lsb-release \
        htop net-tools ufw supervisor \
        build-essential python3-pip expect
    
    # Set timezone
    timedatectl set-timezone UTC
    
    # Configure hostname
    hostnamectl set-hostname "$MAIN_DOMAIN"
    echo "$SERVER_IP $MAIN_DOMAIN" >> /etc/hosts
    
    # Create swap
    if [ ! -f /swapfile ]; then
        fallocate -l 4G /swapfile
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile
        echo '/swapfile none swap sw 0 0' >> /etc/fstab
        sysctl vm.swappiness=10
        sysctl vm.vfs_cache_pressure=50
    fi
    
    print_message "System prepared successfully"
}

# Step 2: Security setup
setup_security() {
    print_message "Step 2/10: Configuring security..."
    
    # Configure firewall
    ufw --force disable
    ufw --force reset
    
    ufw allow 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    
    ufw --force enable
    
    # Configure SSH for root access
    sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
    systemctl restart ssh

    
    print_message "Security configured"
}

# Step 3: Install Nginx and PHP
install_nginx_php() {
    print_message "Step 3/10: Installing Nginx and PHP..."
    
    # Add repositories
    add-apt-repository ppa:ondrej/php -y
    add-apt-repository ppa:ondrej/nginx -y
    apt update -y
    
    # Install Nginx
    apt install -y nginx
    
    # Install PHP 8.3 with extensions
    apt install -y php8.3 php8.3-fpm php8.3-common php8.3-mysql \
        php8.3-xml php8.3-curl php8.3-gd php8.3-mbstring php8.3-zip \
        php8.3-bcmath php8.3-intl php8.3-redis php8.3-memcached \
        php8.3-imagick php8.3-opcache
    
    # Configure PHP
    PHP_INI="/etc/php/8.3/fpm/php.ini"
    sed -i 's/max_execution_time = .*/max_execution_time = 300/' $PHP_INI
    sed -i 's/memory_limit = .*/memory_limit = 512M/' $PHP_INI
    sed -i 's/post_max_size = .*/post_max_size = 100M/' $PHP_INI
    sed -i 's/upload_max_filesize = .*/upload_max_filesize = 100M/' $PHP_INI
    
    # Restart PHP
    systemctl restart php8.3-fpm
    
    print_message "Nginx and PHP installed"
}

#!/bin/bash


# Step 4: Configure Nginx (with improved SSL challenge handling)
configure_nginx() {
    print_message "Step 4/10: Configuring Nginx..."
    
    # Create web root directory
    WEB_ROOT="/var/www/$MAIN_DOMAIN"
    mkdir -p $WEB_ROOT/public
    echo "<?php phpinfo(); ?>" > $WEB_ROOT/public/index.php
    chown -R www-data:www-data $WEB_ROOT
    
    # Create ACME challenge directory
    mkdir -p /var/www/letsencrypt/.well-known/acme-challenge
    chown -R www-data:www-data /var/www/letsencrypt
    
    # Create Nginx configuration
    NGINX_CONF="/etc/nginx/sites-available/$MAIN_DOMAIN"
    cat > $NGINX_CONF <<NGINX_CONFIG
server {
    listen 80;
    server_name $MAIN_DOMAIN;
    
    root $WEB_ROOT/public;
    index index.php index.html index.htm;
    
    # ACME challenge location
    location ^~ /.well-known/acme-challenge/ {
        root /var/www/letsencrypt;
        default_type "text/plain";
        try_files \$uri =404;
    }
    
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
    }
    
    location ~ /\.ht {
        deny all;
    }
}
NGINX_CONFIG
    
    # Remove existing symlink if it exists
    if [ -L "/etc/nginx/sites-enabled/$MAIN_DOMAIN" ]; then
        rm -f "/etc/nginx/sites-enabled/$MAIN_DOMAIN"
        print_warning "Removed existing symlink for $MAIN_DOMAIN"
    fi
    
    # Remove default config if it exists
    if [ -L "/etc/nginx/sites-enabled/default" ]; then
        rm -f "/etc/nginx/sites-enabled/default"
        print_message "Removed default Nginx config"
    fi
    
    # Create new symlink
    ln -s $NGINX_CONF "/etc/nginx/sites-enabled/$MAIN_DOMAIN"
    
    # Test and reload Nginx
    nginx -t
    systemctl reload nginx
    
    print_message "Nginx configured for $MAIN_DOMAIN"
}

# Step 5: Install Let's Encrypt SSL (using webroot method)

install_ssl() {
    print_message "Step 5/10: Installing Let's Encrypt SSL using webroot method..."

    apt install -y certbot


    if certbot certonly --webroot --non-interactive --agree-tos -m "$SSL_EMAIL" -d "$MAIN_DOMAIN" -w /var/www/letsencrypt; then
        print_message "SSL certificate obtained for $MAIN_DOMAIN"

        SSL_CONF="/etc/nginx/sites-available/$MAIN_DOMAIN"
        cat > "$SSL_CONF" <<NGINX_SSL
server {
    listen 80;
    server_name $MAIN_DOMAIN;

    location ^~ /.well-known/acme-challenge/ {
        root /var/www/letsencrypt;
        default_type "text/plain";
        try_files \$uri =404;
    }

    location / { return 301 https://\$host\$request_uri; }
}

server {
    listen 443 ssl;
    http2 on;
    server_name $MAIN_DOMAIN;

    ssl_certificate     /etc/letsencrypt/live/$MAIN_DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$MAIN_DOMAIN/privkey.pem;
    ssl_trusted_certificate /etc/letsencrypt/live/$MAIN_DOMAIN/chain.pem;

    root $WEB_ROOT/public;
    index index.php index.html index.htm;

    location /phpmyadmin {
        alias /usr/share/phpmyadmin;
        index index.php;

        location ~* ^/phpmyadmin/(.+\.(?:css|js|png|jpg|jpeg|gif|ico|svg|ttf|woff|woff2))$ {
            try_files \$uri =404;
        }

        location ~ ^/phpmyadmin/(.+\.php)\$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/run/php/php8.3-fpm.sock;
            fastcgi_param HTTPS on;
            fastcgi_param HTTP_X_FORWARDED_PROTO https;
            fastcgi_param SCRIPT_FILENAME \$request_filename;
        }
  
        location ~ ^/phpmyadmin/(doc|sql|setup)/ { deny all; }
    }

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_param HTTPS on;
        fastcgi_param HTTP_X_FORWARDED_PROTO https;
    }

    location ~ /\.ht {
        deny all;
    }
}
NGINX_SSL

    
        ln -sf "$SSL_CONF" "/etc/nginx/sites-enabled/$MAIN_DOMAIN"

        rm -f "/etc/nginx/sites-enabled/ssl-$MAIN_DOMAIN" "/etc/nginx/sites-available/ssl-$MAIN_DOMAIN"

        rm -f /etc/nginx/conf.d/phpmyadmin.conf

        nginx -t && systemctl reload nginx
        print_message "SSL configured for $MAIN_DOMAIN (single vhost, no redirect loops)"
    else
        print_warning "Failed to obtain SSL certificate for $MAIN_DOMAIN"
        print_warning "You can run manually after DNS propagation:"
        print_warning "certbot certonly --webroot -w /var/www/letsencrypt -d $MAIN_DOMAIN"
    fi

    (crontab -l 2>/dev/null; echo "0 3 * * * certbot renew --quiet --post-hook 'systemctl reload nginx'") | crontab -

    print_message "SSL installation completed"
}

# Step 6: Install and configure MySQL (with root password fix)
install_mysql() {
    print_message "Step 6/10: Installing MySQL..."

    apt install -y mysql-server

    systemctl enable --now mysql

    if mysql --protocol=socket -uroot -e "SELECT 1" >/dev/null 2>&1; then
        print_info "Configuring MySQL root via local socket (auth_socket)."
        mysql --protocol=socket -uroot <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASS}';
FLUSH PRIVILEGES;
SQL
    else
        print_info "Configuring MySQL root via debian-sys-maint account."
        mysql --defaults-file=/etc/mysql/debian.cnf <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASS}';
FLUSH PRIVILEGES;
SQL
    fi

    cat > /etc/mysql/conf.d/optimization.cnf <<MYSQL_CONFIG
[mysqld]
max_connections = 500
innodb_buffer_pool_size = 1G
innodb_log_file_size = 256M
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT
thread_cache_size = 100
table_open_cache = 2000
MYSQL_CONFIG

    systemctl restart mysql

    print_message "MySQL installed and configured"
}

# Step 7: Install phpMyAdmin (standalone)
install_phpmyadmin() {
    print_message "Step 7/10: Installing phpMyAdmin..."

    apt install -y phpmyadmin

    rm -f /etc/nginx/conf.d/phpmyadmin.conf

    systemctl reload nginx

    print_message "phpMyAdmin available at: https://$MAIN_DOMAIN/phpmyadmin"
}


# Step 8: Install Redis and Memcached
install_cache() {
    print_message "Step 8/10: Installing Redis and Memcached..."
    
    apt install -y redis-server memcached
    
    # Configure Redis
    sed -i "s/# requirepass .*/requirepass $REDIS_PASS/" /etc/redis/redis.conf
    sed -i 's/supervised no/supervised systemd/' /etc/redis/redis.conf
    sed -i 's/# maxmemory <bytes>/maxmemory 512mb/' /etc/redis/redis.conf
    sed -i 's/# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/' /etc/redis/redis.conf
    
    systemctl restart redis-server
    systemctl restart memcached
    
    print_message "Cache systems installed"
}
# Step 8.5: Configure Supervisor for Laravel Queue Workers
configure_supervisor() {
    print_message "Step 8.5/10: Configuring Supervisor for Laravel queues..."
    
    # Create a generic Laravel worker template
    cat > /etc/supervisor/conf.d/laravel-worker.conf.template << 'SUPERVISOR_TEMPLATE'
;=======================================================
; Laravel Queue Worker Configuration Template
; 
; Instructions:
; 1. Copy this file: cp laravel-worker.conf.template your-project.conf
; 2. Replace PROJECT_NAME with your project name
; 3. Replace PROJECT_PATH with your project path
; 4. Adjust numprocs based on your server capacity
; 5. Run: supervisorctl reread && supervisorctl update
;=======================================================

[program:PROJECT_NAME-worker]
process_name=%(program_name)s_%(process_num)02d
command=php PROJECT_PATH/artisan queue:work redis --sleep=3 --tries=3 --max-time=3600
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
user=www-data
numprocs=4
redirect_stderr=true
stdout_logfile=/var/log/PROJECT_NAME-worker.log
stopwaitsecs=3600

; Optional: Add queue for emails
[program:PROJECT_NAME-email]
process_name=%(program_name)s_%(process_num)02d
command=php PROJECT_PATH/artisan queue:work redis --queue=emails --sleep=3 --tries=3
autostart=true
autorestart=true
user=www-data
numprocs=2
redirect_stderr=true
stdout_logfile=/var/log/PROJECT_NAME-email.log

; Optional: Add horizon if using Laravel Horizon
;[program:PROJECT_NAME-horizon]
;command=php PROJECT_PATH/artisan horizon
;autostart=true
;autorestart=true
;user=www-data
;redirect_stderr=true
;stdout_logfile=/var/log/PROJECT_NAME-horizon.log
;stopwaitsecs=3600
SUPERVISOR_TEMPLATE

    # Create example configuration for the current domain
    if [ ! -z "$MAIN_DOMAIN" ]; then
        SAFE_DOMAIN=$(echo $MAIN_DOMAIN | tr '.' '-')
        PROJECT_PATH="/var/www/$MAIN_DOMAIN"
        
        cat > /etc/supervisor/conf.d/${SAFE_DOMAIN}-worker.conf << SUPERVISOR_CONFIG
;=======================================================
; Laravel Queue Worker for $MAIN_DOMAIN
; Auto-generated configuration
;=======================================================

[program:${SAFE_DOMAIN}-worker]
process_name=%(program_name)s_%(process_num)02d
command=php ${PROJECT_PATH}/artisan queue:work redis --sleep=3 --tries=3 --max-time=3600
autostart=false
autorestart=true
stopasgroup=true
killasgroup=true
user=www-data
numprocs=4
redirect_stderr=true
stdout_logfile=/var/log/${SAFE_DOMAIN}-worker.log
stopwaitsecs=3600
startsecs=0

; Note: autostart is set to false because Laravel might not be installed yet
; To start the workers after installing Laravel:
; supervisorctl reread
; supervisorctl update
; supervisorctl start ${SAFE_DOMAIN}-worker:*
SUPERVISOR_CONFIG
        
        print_info "Supervisor config created for $MAIN_DOMAIN"
        print_info "Config file: /etc/supervisor/conf.d/${SAFE_DOMAIN}-worker.conf"
    fi
    
    # Create a helper script for easy queue management
    cat > /usr/local/bin/laravel-queue << 'QUEUE_SCRIPT'
#!/bin/bash

# Laravel Queue Management Helper
# Usage: laravel-queue [start|stop|restart|status] [project-name]

PROJECT=$2
ACTION=$1

if [ -z "$ACTION" ]; then
    echo "Laravel Queue Manager"
    echo "Usage: laravel-queue [start|stop|restart|status] [project-name]"
    echo ""
    echo "Examples:"
    echo "  laravel-queue status                    # Show all workers"
    echo "  laravel-queue start example-com         # Start specific project"
    echo "  laravel-queue restart all               # Restart all workers"
    echo ""
    echo "Available projects:"
    ls -1 /etc/supervisor/conf.d/*.conf | grep -v template | xargs -n1 basename | sed 's/-worker.conf//'
    exit 1
fi

case $ACTION in
    start)
        if [ "$PROJECT" == "all" ]; then
            supervisorctl start all
        elif [ ! -z "$PROJECT" ]; then
            supervisorctl start ${PROJECT}-worker:*
        else
            echo "Please specify project name or 'all'"
        fi
        ;;
    stop)
        if [ "$PROJECT" == "all" ]; then
            supervisorctl stop all
        elif [ ! -z "$PROJECT" ]; then
            supervisorctl stop ${PROJECT}-worker:*
        else
            echo "Please specify project name or 'all'"
        fi
        ;;
    restart)
        if [ "$PROJECT" == "all" ]; then
            supervisorctl restart all
        elif [ ! -z "$PROJECT" ]; then
            supervisorctl restart ${PROJECT}-worker:*
        else
            echo "Please specify project name or 'all'"
        fi
        ;;
    status)
        supervisorctl status
        ;;
    reload)
        supervisorctl reread
        supervisorctl update
        echo "Configuration reloaded"
        ;;
    *)
        echo "Invalid action. Use: start, stop, restart, status, or reload"
        ;;
esac
QUEUE_SCRIPT
    
    chmod +x /usr/local/bin/laravel-queue
    
    # Create log rotation for supervisor logs
    cat > /etc/logrotate.d/laravel-workers << 'LOGROTATE'
/var/log/*-worker.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 640 www-data www-data
    sharedscripts
    postrotate
        supervisorctl restart all > /dev/null
    endscript
}
LOGROTATE
    
    # Reload supervisor to recognize new configurations
    supervisorctl reread
    supervisorctl update
    
    print_message "Supervisor configured for Laravel queues"
    print_info "Template available at: /etc/supervisor/conf.d/laravel-worker.conf.template"
    print_info "Helper command: laravel-queue [start|stop|restart|status]"
}


# Step 9: Install development tools
install_tools() {
    print_message "Step 9/10: Installing development tools..."
    
    # Install Composer
    cd /tmp
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    chmod +x /usr/local/bin/composer
    
    # Install Node.js
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt install -y nodejs
    
    # Install Yarn and PM2
    npm install -g yarn pm2
    
    print_message "Development tools installed"
}

# Step 10: Setup backup and save credentials
setup_backup() {
    print_message "Step 10/10: Setting up backup and saving credentials..."
    
    mkdir -p /root/backups
    
    # Create secure MySQL config
    echo -e "[mysqldump]\nuser=root\npassword=\"$MYSQL_ROOT_PASS\"" > /root/.my.cnf
    chmod 600 /root/.my.cnf
    
    # Create backup script
    cat > /usr/local/bin/backup.sh <<'BACKUP_SCRIPT'
#!/bin/bash
BACKUP_DIR="/root/backups"
DATE=$(date +%Y%m%d_%H%M%S)
mysqldump --defaults-file=/root/.my.cnf --all-databases > $BACKUP_DIR/mysql_$DATE.sql
tar -czf $BACKUP_DIR/files_$DATE.tar.gz /var/www
find $BACKUP_DIR -mtime +7 -delete
BACKUP_SCRIPT
    
    chmod +x /usr/local/bin/backup.sh
    
    # Add to cron
    (crontab -l 2>/dev/null; echo "0 2 * * * /usr/local/bin/backup.sh") | crontab -
    
    # Save all credentials to file
    cat > $CREDENTIALS_FILE <<CREDENTIALS
═══════════════════════════════════════════════════════════════
                    SERVER CREDENTIALS
═══════════════════════════════════════════════════════════════
Generated: $(date)
Server IP: $SERVER_IP
Domain: $MAIN_DOMAIN

─────────────────────────────────────────────────────────────
MYSQL DATABASE
─────────────────────────────────────────────────────────────
Host: localhost
Port: 3306
Root Username: root
Root Password: $MYSQL_ROOT_PASS

─────────────────────────────────────────────────────────────
PHPMYADMIN
─────────────────────────────────────────────────────────────
URL: http://$MAIN_DOMAIN/phpmyadmin
Username: root
Password: $MYSQL_ROOT_PASS

─────────────────────────────────────────────────────────────
REDIS CACHE
─────────────────────────────────────────────────────────────
Host: localhost
Port: 6379
Password: $REDIS_PASS

─────────────────────────────────────────────────────────────
WEBSITE DIRECTORY
─────────────────────────────────────────────────────────────
Path: /var/www/$MAIN_DOMAIN/public

═══════════════════════════════════════════════════════════════
CREDENTIALS
    
    chmod 600 $CREDENTIALS_FILE
    
    # Display credentials
    clear
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║         🎉 INSTALLATION COMPLETED SUCCESSFULLY! 🎉           ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    cat $CREDENTIALS_FILE
    
    echo ""
    echo -e "${YELLOW}IMPORTANT:${NC}"
    echo "1. Credentials saved to: $CREDENTIALS_FILE"
    echo "3. MySQL Root: root / $MYSQL_ROOT_PASS"
    echo "4. Website root: /var/www/$MAIN_DOMAIN/public"
    echo "5. If SSL failed, run after DNS propagation:"
    echo "   certbot --nginx -d $MAIN_DOMAIN"
    echo "6. Reboot recommended: reboot"
    echo ""
    
    print_message "Backup configured"
}

# Main execution
main() {
    check_root
    show_banner
    get_user_input
    
    # Start logging
    exec > >(tee -a "$LOG_FILE") 2>&1
    
    prepare_system
    setup_security
    install_nginx_php
    configure_nginx
    install_ssl
    install_mysql
    install_phpmyadmin
    install_cache
    configure_supervisor    
    install_tools
    setup_backup
    
    print_message "Installation complete! Please reboot your server."
    print_info "Full installation log: $LOG_FILE"
}

# Run the script
main "$@"
