FROM php:8.4-apache   

RUN apt-get update && \
    apt-get -y install \
    apache2-utils pwgen vim nano \
    libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev \
    graphviz zip unzip git libpq-dev \
    libmemcached-dev memcached libmemcached-tools wget curl rpl libapache2-mod-evasive \
    libpng-dev zlib1g-dev libxml2-dev libzip-dev libonig-dev \
    libapache2-mod-security2 libcurl4-openssl-dev openssl  \
    libssl-dev procps htop  && a2dismod mpm_event && a2dismod mpm_worker && a2enmod mpm_prefork && a2enmod rewrite 
    
RUN docker-php-ext-install pdo  pdo_mysql  pdo_pgsql  mbstring  opcache  gd  soap  xml    sockets  

RUN echo "" >> /usr/local/etc/php/php.ini && \  
    echo "error_log = /tmp/php_errors.log" >> /usr/local/etc/php/php.ini && \
    echo "log_errors = On" >> /usr/local/etc/php/php.ini && \
    echo "display_errors = Off" >> /usr/local/etc/php/php.ini && \
    echo "memory_limit = 256M" >> /usr/local/etc/php/php.ini && \
    echo "max_execution_time = 120" >> /usr/local/etc/php/php.ini && \
    echo "error_reporting = E_ALL" >> /usr/local/etc/php/php.ini && \
    echo "file_uploads = On" >> /usr/local/etc/php/php.ini && \
    echo "post_max_size = 100M" >> /usr/local/etc/php/php.ini && \
    echo "upload_max_filesize = 100M" >> /usr/local/etc/php/php.ini && \
    echo "session.gc_maxlifetime = 14000" >> /usr/local/etc/php/php.ini  && \
    echo "session.name = CUSTOMSESSID"   >> /usr/local/etc/php/php.ini  && \
    echo "session.use_only_cookies = 1"        >> /usr/local/etc/php/php.ini  && \
    echo "session.cookie_httponly = 1"      >> /usr/local/etc/php/php.ini  && \
    echo "session.cookie_secure = 1"      >> /usr/local/etc/php/php.ini  && \
    echo "session.cookie_samesite  = Strict"      >> /usr/local/etc/php/php.ini  && \
    echo "session.use_trans_sid = 0"           >> /usr/local/etc/php/php.ini  && \
    echo "session.entropy_file = /dev/urandom" >> /usr/local/etc/php/php.ini  && \
    echo "session.entropy_length = 32"         >> /usr/local/etc/php/php.ini     

RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

RUN rm /etc/apache2/mods-enabled/evasive.conf   && \
    echo '<IfModule mod_evasive20.c>'             >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSHashTableSize 2048'                >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSPageCount 10'                      >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSSiteCount 200'                     >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSPageInterval 2'                    >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSSiteInterval 2'                    >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSBlockingPeriod 10'                 >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSLogDir "/var/log/apache2/evasive"' >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '</IfModule>'                            >> /etc/apache2/mods-enabled/evasive.conf 

RUN rpl "AllowOverride None" "AllowOverride All" /etc/apache2/apache2.conf
   
EXPOSE 80
