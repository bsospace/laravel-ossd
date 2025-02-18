# ใช้ PHP 8.2 และ Apache
FROM php:8.2-apache

# ติดตั้งโปรแกรมที่ Laravel ต้องใช้
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd

# เปิด mod_rewrite ของ Apache
RUN a2enmod rewrite

# ติดตั้ง Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# คัดลอกโค้ด Laravel ไปที่ /var/www/html
COPY . /var/www/html

# ตั้งค่า permission ให้กับ Laravel
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html \
    && chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# ติดตั้ง dependencies ของ Laravel
WORKDIR /var/www/html
RUN composer install --no-dev --optimize-autoloader

# คัดลอกไฟล์ Apache config
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# เปิดพอร์ต 80
EXPOSE 80

# รัน Apache
CMD ["apache2-foreground"]
