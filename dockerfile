# ใช้ PHP 8.2 และ Apache 2.4 จาก Docker Hub
FROM php:8.2-apache

# ติดตั้งโปรแกรมเสริมที่ Laravel ต้องการ
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd

# เปิดใช้ mod_rewrite ของ Apache
RUN a2enmod rewrite

# ติดตั้ง Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# คัดลอกไฟล์ Laravel ไปที่ /var/www/html
COPY . /var/www/html

# ตั้งค่าเจ้าของไฟล์และโฟลเดอร์
RUN chown -R www-data:www-data /var/www/html

# ตั้งค่าสิทธิ์ของไฟล์และโฟลเดอร์
RUN chmod -R 755 /var/www/html

# ติดตั้ง dependencies ของ Laravel
WORKDIR /var/www/html
RUN composer install --no-dev --optimize-autoloader

# คัดลอกไฟล์ Apache config
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# เปิดพอร์ต 80
EXPOSE 80

# รัน Apache
CMD ["apache2-foreground"]
