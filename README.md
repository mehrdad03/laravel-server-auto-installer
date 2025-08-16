# 🚀 Laravel Server Auto Installer - Nginx Edition

[![Ubuntu](https://img.shields.io/badge/Ubuntu%20OS-orange)](https://ubuntu.com/)
[![PHP](https://img.shields.io/badge/PHP-8.3-777BB4)](https://www.php.net/)
[![Nginx](https://img.shields.io/badge/Nginx-Latest-009639)](https://nginx.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1)](https://www.mysql.com/)
[![Laravel](https://img.shields.io/badge/Laravel-Ready-FF2D20)](https://laravel.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Stars](https://img.shields.io/github/stars/mehrdad03/laravel-server-auto-installer-nginx-edition?style=social)](https://github.com/mehrdad03/laravel-server-auto-installer-nginx-edition/stargazers)

A powerful bash script that automatically configures a production-ready Laravel/PHP web server on Ubuntu with Nginx, SSL, Supervisor for queue workers, and all essential tools in one command.

## 🎯 Purpose

This script is designed for developers and system administrators who need to quickly deploy a production-ready web server optimized for Laravel and modern PHP applications. It automates hours of manual configuration into a 15-minute installation process.

## ✨ Key Features

- **Complete LEMP Stack** - Nginx + MySQL + PHP-FPM 8.3
- **SSL/HTTPS Ready** - Automatic Let's Encrypt SSL with webroot verification
- **Laravel Optimized** - Pre-configured for Laravel applications
- **Queue Worker Ready** - Supervisor installed and configured for Laravel queues
- **Security Hardened** - UFW firewall, secure MySQL, SSH protection
- **Performance Tuned** - Optimized configurations based on server resources
- **Automated Backups** - Daily MySQL and file backups with 7-day retention
- **Zero Downtime SSL** - Webroot method prevents service interruption

## 🚀 Quick Installation

### Method 1: One-Line Installation (Recommended)
```bash
bash <(curl -s https://raw.githubusercontent.com/mehrdad03/laravel-server-auto-installer/main/install.sh)
```

### Method 2: Download and Run
```bash
wget -O install.sh https://raw.githubusercontent.com/mehrdad03/laravel-server-auto-installer/main/install.sh && bash install.sh
```

### Method 3: Clone and Run
```bash
git clone https://github.com/mehrdad03/laravel-server-auto-installer.git
cd laravel-server-auto-installer
bash install.sh
```

## 📋 Prerequisites

Before running the installer, ensure you have:

- ✅ **Fresh Ubuntu Installation** (20.04 or 22.04 LTS)
- ✅ **Root Access** via SSH
- ✅ **Minimum 2GB RAM** (4GB recommended)
- ✅ **20GB Free Disk Space**
- ✅ **Valid Domain Name**
- ✅ **DNS A Records** pointing to your server IP:
  ```
  Type    Name    Value           TTL
  A       @       YOUR_SERVER_IP  300
  A       www     YOUR_SERVER_IP  300
  ```

## 📦 Complete Package List

### Web Server Stack
- **Nginx** (Latest from PPA)
  - HTTP/2 enabled
  - Gzip compression
  - Optimized for PHP-FPM
  - Virtual host configuration
  - ACME challenge support

- **PHP 8.3** with PHP-FPM and Extensions:
  - `php8.3-fpm` - FastCGI Process Manager
  - `php8.3-common` - Common files
  - `php8.3-mysql` - MySQL database support
  - `php8.3-xml` - XML parsing
  - `php8.3-curl` - cURL support
  - `php8.3-gd` - Image processing
  - `php8.3-mbstring` - Multibyte string support
  - `php8.3-zip` - ZIP archives
  - `php8.3-bcmath` - Arbitrary precision mathematics
  - `php8.3-intl` - Internationalization
  - `php8.3-redis` - Redis support
  - `php8.3-memcached` - Memcached support
  - `php8.3-imagick` - ImageMagick
  - `php8.3-opcache` - Bytecode cache

### Database & Management
- **MySQL 8.0** 
  - Secured installation
  - Optimized buffer pool (1GB)
  - 500 max connections
  - Native password authentication
  - Automated root password generation

- **phpMyAdmin** (Latest from APT)
  - Web-based database management
  - Accessible at `https://yourdomain.com/phpmyadmin`
  - Integrated with Nginx
  - Secured configuration

### Caching Systems
- **Redis Server**
  - Password protected
  - 512MB memory limit
  - LRU eviction policy
  - Systemd supervised
  - Ready for Laravel queues

- **Memcached**
  - 128MB memory allocation
  - 2048 connection limit
  - Optimized for sessions

### Queue Management
- **Supervisor**
  - Process monitoring and control
  - Auto-restart on failure
  - Log management
  - Ready for Laravel queue workers
  - Template configuration included

### Development Tools
- **Composer** - Latest PHP dependency manager
- **Node.js LTS** - JavaScript runtime (latest LTS version)
- **NPM** - Node package manager
- **Yarn** - Fast, reliable package manager
- **PM2** - Production process manager for Node.js
- **Git** - Version control system

### Security & System Tools
- **UFW Firewall** - Configured with minimal open ports (22, 80, 443)
- **Let's Encrypt Certbot** - Free SSL certificates with auto-renewal
- **Htop** - Interactive process viewer
- **Net-tools** - Network utilities
- **Build-essential** - Compilation tools (gcc, make, etc.)
- **Python3 + pip** - Python runtime and package manager
- **Expect** - Automation tool

### System Optimizations
- **4GB Swap File** - Virtual memory for stability
- **Timezone Configuration** - Set to UTC
- **Hostname Setup** - Proper system identification
- **SSH Configuration** - Root access maintained with password
- **Log Rotation** - Automated log management

## 📝 Installation Process

The script executes 10 automated steps:

```
Step 1/10: Preparing system...
         ✓ System updates
         ✓ Essential packages installation
         ✓ 4GB Swap file creation
         ✓ Timezone configuration (UTC)
         ✓ Hostname setup

Step 2/10: Configuring security...
         ✓ UFW firewall rules
         ✓ SSH configuration

Step 3/10: Installing Nginx and PHP...
         ✓ Nginx web server (latest)
         ✓ PHP 8.3 with all extensions
         ✓ PHP-FPM optimization

Step 4/10: Configuring Nginx...
         ✓ Virtual host setup
         ✓ PHP-FPM integration
         ✓ ACME challenge directory

Step 5/10: Installing Let's Encrypt SSL...
         ✓ SSL certificate generation
         ✓ HTTPS configuration
         ✓ HTTP to HTTPS redirect
         ✓ Auto-renewal cron job

Step 6/10: Installing MySQL...
         ✓ MySQL 8.0 server
         ✓ Secure installation
         ✓ Performance optimization
         ✓ Root password setup

Step 7/10: Installing phpMyAdmin...
         ✓ Web interface setup
         ✓ Nginx integration
         ✓ Secure access configuration

Step 8/10: Installing Redis and Memcached...
         ✓ Redis with password protection
         ✓ Memcached service
         ✓ Memory optimization

Step 9/10: Installing development tools...
         ✓ Composer installation
         ✓ Node.js & NPM
         ✓ Yarn & PM2
         ✓ Supervisor configuration

Step 10/10: Setting up backup...
          ✓ Backup script creation
          ✓ Cron job automation
          ✓ Credentials saved
```

## 🔐 Post-Installation Access

After successful installation, all credentials are displayed and saved to `/root/server-credentials.txt`:

### System Access
```
SSH Root Access:
  Host: YOUR_SERVER_IP
  Username: root
  Password: [auto-generated-16-chars]
```

### Database Access
```
MySQL Database:
  Host: localhost
  Port: 3306
  Username: root
  Password: [auto-generated-16-chars]

phpMyAdmin:
  URL: https://yourdomain.com/phpmyadmin
  Username: root
  Password: [same as MySQL]
```

### Cache Services
```
Redis:
  Host: localhost
  Port: 6379
  Password: [auto-generated-12-chars]

Memcached:
  Host: localhost
  Port: 11211
```

### Important Paths
```
Web Root:         /var/www/yourdomain.com/public
Nginx Config:     /etc/nginx/sites-available/yourdomain.com
PHP Config:       /etc/php/8.3/fpm/php.ini
MySQL Config:     /etc/mysql/conf.d/optimization.cnf
Supervisor Config: /etc/supervisor/conf.d/
Credentials:      /root/server-credentials.txt
Backup Location:  /root/backups/
Installation Log: /var/log/laravel-installer-*.log
```

## 🌐 Laravel Deployment Guide

### Step 1: Deploy Your Laravel Application

```bash
# Navigate to web directory
cd /var/www/yourdomain.com

# Clone your Laravel project
git clone https://github.com/your-username/your-laravel-app.git .

# Install dependencies
composer install --optimize-autoloader --no-dev

# Set permissions
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# Configure environment
cp .env.example .env
nano .env  # Edit database credentials and settings

# Generate application key
php artisan key:generate

# Run migrations
php artisan migrate --force

# Optimize for production
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan optimize
```

### Step 2: Configure Database

```bash
# Create database for your application
mysql -u root -p

# In MySQL prompt:
CREATE DATABASE laravel_app;
CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'strong_password';
GRANT ALL PRIVILEGES ON laravel_app.* TO 'laravel_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Step 3: Update .env File

```env
APP_NAME="Your App Name"
APP_ENV=production
APP_DEBUG=false
APP_URL=https://yourdomain.com

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_app
DB_USERNAME=laravel_user
DB_PASSWORD=strong_password

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=your_redis_password
REDIS_PORT=6379

CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis
```

## 👷 Supervisor Configuration for Queue Workers

Supervisor is pre-installed and ready for Laravel queue workers.

### Setting Up Queue Workers

#### Method 1: Using Pre-configured Template

```bash
# Copy the template
cp /etc/supervisor/conf.d/laravel-worker.conf.template /etc/supervisor/conf.d/yourdomain-worker.conf

# Edit the configuration
nano /etc/supervisor/conf.d/yourdomain-worker.conf

# Replace PROJECT_NAME with your domain and PROJECT_PATH with your path
# Example: PROJECT_NAME=yourdomain, PROJECT_PATH=/var/www/yourdomain.com
```

#### Method 2: Create New Configuration

```bash
# Create new worker configuration
cat > /etc/supervisor/conf.d/yourdomain-worker.conf << EOF
[program:yourdomain-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/yourdomain.com/artisan queue:work redis --sleep=3 --tries=3 --max-time=3600
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
user=www-data
numprocs=4
redirect_stderr=true
stdout_logfile=/var/log/yourdomain-worker.log
stopwaitsecs=3600
EOF

# Reload supervisor
supervisorctl reread
supervisorctl update
supervisorctl start yourdomain-worker:*
```

### Managing Queue Workers

```bash
# Check worker status
supervisorctl status

# Start workers
supervisorctl start yourdomain-worker:*

# Stop workers
supervisorctl stop yourdomain-worker:*

# Restart workers
supervisorctl restart yourdomain-worker:*

# Start all workers
supervisorctl start all

# View logs
tail -f /var/log/yourdomain-worker.log
```

### Laravel Horizon (Optional)

If using Laravel Horizon for queue management:

```bash
# Install Horizon in your Laravel project
composer require laravel/horizon
php artisan horizon:install

# Create Supervisor configuration for Horizon
cat > /etc/supervisor/conf.d/horizon.conf << EOF
[program:horizon]
process_name=%(program_name)s
command=php /var/www/yourdomain.com/artisan horizon
autostart=true
autorestart=true
user=www-data
redirect_stderr=true
stdout_logfile=/var/log/horizon.log
stopwaitsecs=3600
EOF

# Start Horizon
supervisorctl reread
supervisorctl update
supervisorctl start horizon
```

## 🔧 Configuration Files

### Nginx Virtual Host
Location: `/etc/nginx/sites-available/yourdomain.com`

Features:
- HTTP to HTTPS redirect
- PHP-FPM integration
- Laravel routing support
- phpMyAdmin alias
- Security headers
- Gzip compression
- Static file caching

### PHP Configuration
Location: `/etc/php/8.3/fpm/php.ini`

Optimizations:
- `memory_limit = 512M`
- `upload_max_filesize = 100M`
- `post_max_size = 100M`
- `max_execution_time = 300`
- `opcache.memory_consumption = 256`
- `opcache.max_accelerated_files = 60000`

### MySQL Optimization
Location: `/etc/mysql/conf.d/optimization.cnf`

Settings:
- `innodb_buffer_pool_size = 1G`
- `innodb_log_file_size = 256M`
- `max_connections = 500`
- `thread_cache_size = 100`
- `table_open_cache = 2000`

### Redis Configuration
Location: `/etc/redis/redis.conf`

Settings:
- Password protected
- `maxmemory 512mb`
- `maxmemory-policy allkeys-lru`
- Supervised by systemd

## 🔄 Maintenance Commands

### Service Management
```bash
# Check service status
systemctl status nginx
systemctl status php8.3-fpm
systemctl status mysql
systemctl status redis-server
systemctl status supervisor

# Restart services
systemctl restart nginx
systemctl restart php8.3-fpm
systemctl restart mysql
systemctl restart redis-server
systemctl restart supervisor

# View service logs
journalctl -u nginx -f
journalctl -u php8.3-fpm -f
journalctl -u mysql -f
```

### SSL Certificate Management
```bash
# Test SSL renewal
certbot renew --dry-run

# Force renewal
certbot renew --force-renewal

# Check certificate expiry
certbot certificates

# View SSL configuration
nginx -T | grep ssl
```

### Backup Management
```bash
# Run manual backup
/usr/local/bin/backup.sh

# View backup files
ls -lah /root/backups/

# Restore MySQL backup
mysql -u root -p < /root/backups/mysql_20240101_120000.sql

# Create full server backup
tar -czf /root/full-backup-$(date +%Y%m%d).tar.gz \
  /var/www /etc/nginx /etc/php /etc/mysql /etc/supervisor
```

### Log Files
```bash
# Nginx logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log

# PHP logs
tail -f /var/log/php8.3-fpm.log

# MySQL logs
tail -f /var/log/mysql/error.log
tail -f /var/log/mysql/slow.log

# Supervisor logs
tail -f /var/log/supervisor/supervisord.log

# Laravel logs
tail -f /var/www/yourdomain.com/storage/logs/laravel.log

# Installation log
cat /var/log/laravel-installer-*.log
```

## 📊 Performance Monitoring

### System Resources
```bash
# Real-time system monitor
htop

# Disk usage
df -h
du -sh /var/www/*

# Memory usage
free -m
vmstat 1

# Network connections
netstat -tulpn
ss -tulpn

# Process list
ps aux | grep -E 'nginx|php|mysql'
```

### Web Server Performance
```bash
# Nginx status
nginx -t
nginx -V

# PHP-FPM status
php-fpm8.3 -t
systemctl status php8.3-fpm

# MySQL performance
mysql -u root -p -e "SHOW STATUS LIKE 'Threads%';"
mysql -u root -p -e "SHOW PROCESSLIST;"

# Redis monitoring
redis-cli -a your_password ping
redis-cli -a your_password info stats
redis-cli -a your_password monitor
```

## 🐛 Troubleshooting

### Common Issues and Solutions

#### SSL Certificate Issues
```bash
# If Let's Encrypt fails due to DNS propagation
# Wait 5-30 minutes for DNS propagation, then:
certbot certonly --webroot -w /var/www/letsencrypt -d yourdomain.com
systemctl reload nginx

# Check DNS propagation
dig +short yourdomain.com
nslookup yourdomain.com 8.8.8.8
```

#### 502 Bad Gateway Error
```bash
# Check if PHP-FPM is running
systemctl status php8.3-fpm
systemctl restart php8.3-fpm

# Check socket exists
ls -la /run/php/php8.3-fpm.sock

# Check Nginx error log
tail -n 50 /var/log/nginx/error.log

# Verify PHP-FPM pool configuration
php-fpm8.3 -t
```

#### Permission Denied Errors
```bash
# Fix web directory permissions
chown -R www-data:www-data /var/www/yourdomain.com
find /var/www/yourdomain.com -type f -exec chmod 644 {} \;
find /var/www/yourdomain.com -type d -exec chmod 755 {} \;

# Laravel specific permissions
chmod -R 775 /var/www/yourdomain.com/storage
chmod -R 775 /var/www/yourdomain.com/bootstrap/cache

# SELinux (if enabled)
setenforce 0  # Temporary disable
```

#### MySQL Connection Issues
```bash
# Test MySQL connection
mysql -u root -p

# If authentication fails
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'new_password';
FLUSH PRIVILEGES;

# Check MySQL is listening
netstat -tlnp | grep 3306
```

#### Queue Workers Not Processing
```bash
# Check supervisor status
supervisorctl status

# Check Laravel queue
php artisan queue:failed
php artisan queue:retry all

# Check Redis connection
redis-cli -a your_password ping

# View worker logs
tail -f /var/log/your-worker.log
```

## 🔒 Security Best Practices

After installation, implement these security measures:

### 1. Change Default Passwords
```bash
# Change root password
passwd root

# Change MySQL root password
mysql -u root -p
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_strong_password';
```

### 2. Setup SSH Key Authentication
```bash
# On your local machine
ssh-keygen -t rsa -b 4096
ssh-copy-id root@your_server_ip

# On server, disable password authentication
nano /etc/ssh/sshd_config
# Set: PasswordAuthentication no
systemctl restart ssh
```

### 3. Configure Fail2ban
```bash
apt install fail2ban
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
systemctl enable fail2ban
systemctl start fail2ban
```

### 4. Enable Automatic Security Updates
```bash
apt install unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
```

### 5. Regular Backups
```bash
# Setup remote backup
rsync -avz /root/backups/ user@backup-server:/backups/

# Or use cloud storage
apt install rclone
rclone config  # Follow prompts
```

### 6. Monitor Server
```bash
# Install monitoring
apt install monit
systemctl enable monit
systemctl start monit
```

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

This script is provided as-is without warranty. Always:
- Test in a development environment first
- Maintain regular backups
- Review security settings for your use case
- Keep all software updated

## 💬 Support

If you encounter issues:

1. Check the installation log: `/var/log/laravel-installer-*.log`
2. Review credentials: `/root/server-credentials.txt`
3. Check service status: `systemctl status nginx php8.3-fpm mysql redis-server`
4. Open an issue on [GitHub](https://github.com/mehrdad03/laravel-server-auto-installer/issues)

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=mehrdad03/laravel-server-auto-installer&type=Date)](https://star-history.com/#mehrdad03/laravel-server-auto-installer&Date)

---

<p align="center">
  Made with ❤️ for the Laravel community
</p>

<p align="center">
  <a href="https://github.com/mehrdad03/laravel-server-auto-installer">
    ⭐ Star this project if you find it helpful!
  </a>
</p>
