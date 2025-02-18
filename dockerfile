# ใช้ PHP 8.2 และ Apache 2.4 จาก Docker Hub
FROM php:8.2-apache

# ติดตั้งส่วนขยายที่จำเป็น
RUN apt update && apt install -y \
    unzip \
    curl \
    git \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# ติดตั้ง Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# เปิดใช้งาน mod_rewrite ของ Apache
RUN a2enmod rewrite

# คัดลอกไฟล์ Laravel ไปที่ /var/www/html
COPY . /var/www/html/
WORKDIR /var/www/html

# ติดตั้ง dependencies ของ Laravel
RUN composer install

# ตั้งค่าเจ้าของไฟล์และโฟลเดอร์
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# คัดลอกไฟล์ Apache config
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# เปิดพอร์ต 80
EXPOSE 80

# สั่งให้ Apache ทำงาน
CMD ["apache2-foreground"]