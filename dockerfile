# ใช้ PHP 8.2 และ Apache 2.4 จาก Docker Hub
FROM php:8.2-apache

# ติดตั้ง PHP extensions ที่จำเป็นสำหรับ Laravel
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd

# เปิดใช้ mod_rewrite ของ Apache (จำเป็นสำหรับ Laravel)
RUN a2enmod rewrite

# คัดลอกไฟล์ Laravel ไปยัง /var/www/html
COPY . /var/www/html/

# ตั้งค่าเจ้าของไฟล์และโฟลเดอร์ให้ Apache อ่านได้
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# คัดลอกไฟล์ Apache config ไปยังตำแหน่งที่ถูกต้อง
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# ติดตั้ง Composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# ติดตั้ง dependencies ของ Laravel
WORKDIR /var/www/html
RUN composer install --no-dev --optimize-autoloader

# เปิด port 80 สำหรับ Apache
EXPOSE 80

# เริ่มต้น Container โดยรัน Apache
CMD ["apache2-foreground"]
