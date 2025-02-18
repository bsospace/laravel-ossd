# ใช้ PHP 8.2 และ Apache
FROM php:8.2-apache

# ติดตั้งแพ็กเกจที่ Laravel ต้องใช้
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

# กำหนด UID และ GID ให้ Apache เป็น 1000 (ให้ตรงกับ user นอก container)
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# คัดลอกโค้ด Laravel ไปที่ /var/www/html
COPY . /var/www/html

# แก้ไขเจ้าของไฟล์ทั้งหมดเป็น www-data เพื่อให้ Composer เขียนไฟล์ได้
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html

# สร้าง `vendor/` ล่วงหน้า และให้สิทธิ์ www-data
USER www-data
RUN mkdir -p /var/www/html/vendor && composer install --no-dev --optimize-autoloader --no-interaction --no-progress

# เปลี่ยนกลับมาเป็น root เพื่อคัดลอก Apache config
USER root
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# เปิดพอร์ต 80
EXPOSE 80

# รัน Apache
CMD ["apache2-foreground"]
